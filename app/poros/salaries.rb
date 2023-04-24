class Salaries
  attr_reader :id, :destination, :forecast, :salaries

  JOB_TITLES = [
    "Data Analyst",
    "Data Scientist",
    "Mobile Developer",
    "QA Engineer",
    "Software Engineer",
    "Systems Administrator",
    "Web Developer"
  ]

  def initialize(data)
    @data = data

    @destination = data[:destination]
    @forecast = parse_forecast
    @salaries = parse_salaries
  end

  private
    def parse_forecast
      {
        "summary": @data[:current][:condition][:text],
        "temperature": "#{@data[:current][:temp_f].to_i} F"
      }
    end

    def parse_salaries
      JOB_TITLES.map do |job|
        salary = @data[:salaries].find { |salary| salary[:job][:title] == job }
        if salary
          {
            "title": job,
            "min": convert_to_currency(salary[:salary_percentiles][:percentile_25]),
            "max": convert_to_currency(salary[:salary_percentiles][:percentile_75])
          }
        end
      end.compact
    end

    def convert_to_currency(number)
      ActionController::Base.helpers.number_to_currency(number)
    end
end