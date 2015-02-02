class TooManyRetriesError < StandardError

  def initialize
    super "APNS Service has reached it's maximum number of retries"
  end

end