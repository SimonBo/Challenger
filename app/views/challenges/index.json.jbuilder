json.array!(@challenges) do |challenge|
  json.extract! challenge, :id, :user_id, :name, :description
  json.url challenge_url(challenge, format: :json)
end
