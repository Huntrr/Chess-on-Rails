json.array!(@users) do |user|
  json.extract! user, :id, :name, :wins, :losses, :rating, :bio
  json.url user_url(user, format: :json)
end
