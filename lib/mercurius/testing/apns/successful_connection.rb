module APNS
  class SuccessfulConnection
    def initialize
      @_open = false
    end

    def open
      @_open = true
      @ssl = FakeSocket.new
      @socket = FakeSocket.new
    end

    def close
      @_open = false
    end

    def closed?
      not @_open
    end

    def write(data)
      @ssl.write data
    end

    def read
    end
  end
end
