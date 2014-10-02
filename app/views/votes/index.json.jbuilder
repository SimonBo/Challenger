json.array!(@votes) do |vote|
  json.extract! vote, :id, :for, :user_id, :dare_id
  json.url vote_url(vote, format: :json)
end
