class Api::V1::SalariesController < Api::ApiController
  def create
    salaries_facade = SalariesFacade.new(params)
    render json: SalariesSerializer.new(salaries_facade.salaries_details), status: 201
  end
end