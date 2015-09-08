module APNS
  HOSTS = {
    development: 'gateway.sandbox.push.apple.com',
    production: 'gateway.push.apple.com',
  }

  @host = ''
  @port = 2195
  @pem = nil

  class << self
    attr_accessor :host, :port, :pem

    def mode=(mode)
      @host = HOSTS.fetch(mode.to_sym) { raise InvalidApnsModeError.new }
    end
  end
end
