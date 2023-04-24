class Api::V1::SalariesController < Api::ApiController
  def create
    if params["destination"].blank? || !params.keys.include?("destination")
      raise ActionController::ParameterMissing.new("Missing destination") 
    else
      salaries_facade = SalariesFacade.new(params)
      render json: SalariesSerializer.new(salaries_facade.salaries_details), status: 201
    end
  end
end