class ErrorSerializer
  def initialize(exception = nil)
    @exception = exception
  end

  def errors
    {
      "message": error_message,
      "errors": parse_error_message
    }
  end

  def error_message
    if @exception.message.include?(":")
      @exception.message.split(":")[0]
    else
      "your query could not be completed"
    end
  end

  def parse_error_message
    return [@exception.message] unless @exception.message.include?(":")

    colon_index = @exception.message.index(":")
    @exception.message[(colon_index + 2)..-1].split(", ")
  end

  def status
    return 400 if @exception.class == ActiveRecord::RecordInvalid
  end

  def invalid_credentials
    {
      "message": "Invalid Credentials",
      "errors": "Email or password is incorrect"
    }
  end

  def invalid_api_key
    {
      "message": "Invalid Credentials",
      "errors": "Unauthorized API key"
    }
  end
end
