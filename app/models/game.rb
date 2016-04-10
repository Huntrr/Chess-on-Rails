class Game < ActiveRecord::Base
  belongs_to :white_player, class_name: 'User'
  belongs_to :black_player, class_name: 'User'

  def update_players
    self.white_player.update_wins_losses
    self.black_player.update_wins_losses
  end
end
