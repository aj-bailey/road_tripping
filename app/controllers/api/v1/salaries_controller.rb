class Api::V1::SalariesController < Api::ApiController
  def create
    salary_facade = SalaryFacade.new(params)
    render json: SalarySerializer.new(salary_facade.salary_details), status: 201
  end
end