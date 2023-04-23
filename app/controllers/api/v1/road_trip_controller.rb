class Api::V1::RoadTripController < Api::ApiController
  def create
    road_trip_facade = RoadTripFacade.new(params)

    render json: RoadTripSerializer.new(road_trip_facade.trip_details)
  end
end