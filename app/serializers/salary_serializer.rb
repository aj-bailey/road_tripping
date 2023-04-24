class SalarySerializer
  include JSONAPI::Serializer
  attributes :destination, :forecast, :salaries
end
