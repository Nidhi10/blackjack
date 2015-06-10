class MoveCard < ActiveRecord::Base
  belongs_to :move
  belongs_to :card
end
