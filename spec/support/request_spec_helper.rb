module RequestSpecHelper
  # Parse JSON response to ruby hash
  def json
    JSON.parse(response.body, symolize_names: true)
  end
end
