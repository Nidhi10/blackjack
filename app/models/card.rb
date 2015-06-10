class Card < ActiveRecord::Base
  has_many :move_cards
  has_many :moves, through: :move_cards
end
