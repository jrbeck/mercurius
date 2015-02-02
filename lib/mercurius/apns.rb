module APNS
  @host = ''
  @port = 2195
  @pem = nil

  class << self
    attr_accessor :host, :port, :pem
  end

end