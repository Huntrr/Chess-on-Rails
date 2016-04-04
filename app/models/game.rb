class Game < ActiveRecord::Base
  belongs_to :white_player
  belongs_to :black_player
end
