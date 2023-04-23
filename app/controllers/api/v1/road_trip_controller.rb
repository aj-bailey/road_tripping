class Api::V1::RoadTripController < Api::ApiController
  def create
    return render json: ErrorSerializer.new.invalid_api_key, status: 401 unless User.find_by(api_key: params[:api_key])

    road_trip_facade = RoadTripFacade.new(params)

    render json: RoadTripSerializer.new(road_trip_facade.trip_details)
  end
end
