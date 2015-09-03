class InvalidApnsModeError < StandardError
  def initialize
    super 'Tried to set invalid APNS mode.'
  end
end
