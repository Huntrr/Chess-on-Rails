json.array!(@games) do |game|
  json.extract! game, :id, :white_player_id, :black_player_id, :game_state, :allow_undos, :sandbox_mode
  json.url game_url(game, format: :json)
end
