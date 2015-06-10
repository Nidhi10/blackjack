# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Player.create(name: 'Dealer', email: 'a@a.com', password: 'qwertyuiop')
Player.create(name: 'Test Account', email: 'ab@a.com', password: 'qwertyuiop')

6.times do |i|
  4.times do
    (2..10).each do |j|
      Card.create(number: j, points: j, deck: i + 1)
    end
    Card.create(number: 'A', points: 11, deck: i + 1)
    %w(J Q K).each do |j|
      Card.create(number: j, points: 10, deck: i + 1)
    end
  end
end