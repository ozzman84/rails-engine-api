module RequestSpecHelper
  # Parse JSON response to ruby hash
  def json
    JSON.parse(response.body, symbolize_names: true)
  end

  def item1
    json[:data][0][:attributes]
  end
end
