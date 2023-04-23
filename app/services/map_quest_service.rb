class MapQuestService
  def initialize(params)
    @params = params
    # binding.pry
  end

  def get_location
    get_url("/geocoding/v1/address?key=#{ENV["MAP_QUEST_API_KEY"]}&location=#{@params[:location]}")
  end

  private

    def connection
      Faraday.new(url: "https://www.mapquestapi.com")
    end

    def get_url(url)
      response = connection.get(url)
      JSON.parse(response.body, symbolize_names: true)
    end
end
