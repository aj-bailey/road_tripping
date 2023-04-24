class TeleportService
  def initialize(params)
    @params = params
  end

  def salaries_information
    get_url("api/urban_areas/slug:#{@params[:destination]}/salaries")
  end

  private

    def connection
      Faraday.new(url: "https://api.teleport.org")
    end

    def get_url(url)
      response = connection.get(url)
      JSON.parse(response.body, symbolize_names: true)
    end
end