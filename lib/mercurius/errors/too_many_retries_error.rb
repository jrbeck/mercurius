class TooManyRetriesError < StandardError

  def initialize(e)
    super "APNS Service has reached it's maximum number of retries. Error: #{e.message}"
  end

end
