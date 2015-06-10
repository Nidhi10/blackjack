class Game < ActiveRecord::Base
  belongs_to :player
  belongs_to :winner, class_name: 'Player'

  has_many :moves, autosave: true

  delegate :name, to: :player, prefix: true, allow_nil: true
  delegate :name, to: :winner, prefix: true, allow_nil: true

  validates_numericality_of :bet, greater_than: 1

  before_create :initialize_move_cards

  before_save do
    self.errors.add(:player, 'cannot be system') if self.player_id == 1
  end

  private

  def initialize_move_cards
    self.moves.build(player_id: self.player_id, number_of_cards: 2, is_first_move: true)
    self.moves.build(player_id: Player::SYSTEM, number_of_cards: 1, is_first_move: true)
  end

end
