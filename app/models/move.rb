class Move < ActiveRecord::Base
  belongs_to :game
  belongs_to :player
  has_many :move_cards, autosave: true
  has_many :cards, through: :move_cards
  belongs_to :last_move, class_name: 'Move'

  delegate :name, to: :player, prefix: true, allow_nil: true

  attr_accessor :number_of_cards, :is_first_move

  validates_inclusion_of :status, within: %w(hit stand), allow_blank: true

  validate :game_must_be_on

  before_create :assign_cards

  after_create :calculate_next_move

  before_save :who_moves_next

  def self.total_points(player, game)
    joins(:cards).where(player_id: player, game_id: game).sum(:points)
  end

  def points
    cards.sum(:points)
  end

  private

  def game_must_be_on
    self.errors.add(:game, 'is finished') if self.game.finished? && !is_first_move
  end

  def who_moves_next
    # in case of hit/stand by player
    if self.player_id != Player::SYSTEM && self.status_changed?
      if self.status == 'stand'
        Move.create(game_id: self.game_id, player_id: Player::SYSTEM, status: 'hit', last_move_id: self.id)
      elsif self.status == 'hit'
        Move.create(game_id: self.game_id, player_id: self.player_id, last_move_id: self.id)
      end
    end
  end

  def calculate_next_move
    # if this is the first move of the player, we simply call, player_move_calculation
    if !self.game.finished?
      if self.player_id == Player::SYSTEM
        system_move_calculation if !is_first_move
      else
        player_move_calculation
      end
    end
  end

  def assign_cards
    self.number_of_cards ||= 1
    cards = Card.where('id not in (select move_cards.id from move_cards join moves on moves.id = move_cards.move_id where moves.game_id = ?)', self.game_id).pluck(:id)
    self.number_of_cards.times do
      card_index = rand(cards.length)
      self.move_cards.build card_id: cards[card_index]
      cards.delete_at card_index
    end
  end

  def system_move_calculation
    #dealer wins
    system_points = Move.total_points(Player::SYSTEM, self.game_id)
    if system_points == 21
      self.game.update(winner_id: self.player_id, finished: true, points: system_points)
      # dealer loses
    elsif system_points > 21
      player_points = Move.total_points(self.player_id, self.game_id)
      self.game.update(winner_id: self.game.player_id, finished: true, points: player_points)
      # Hit- another move by dealer!
    elsif system_points <= 16
      Move.create(game_id: self.game_id, player_id: Player::SYSTEM, status: 'hit', last_move_id: self.id)
      # see who has higher points
    elsif system_points >= 17
      player_points = Move.total_points(self.player_id, self.game_id)
      self.game.update(winner_id: player_points > system_points ? self.game.player_id : self.player_id, finished: true, points: player_points > system_points ? player_points : system_points)
    end
  end

  def player_move_calculation
    # player wins
    player_points = Move.total_points(self.player_id, self.game_id)
    if player_points == 21
      self.game.update(winner_id: self.player_id, finished: true, points: player_points)
      Rails.logger.warn(self.game.errors.to_json)
      # player loses
    elsif player_points > 21
      system_points = Move.total_points(Player::SYSTEM, self.game_id)
      self.game.update(winner_id: Player::SYSTEM, finished: true, points: system_points)
    end
  end

end
