module GCM
  class Connection

    attr_accessor :host, :key

    def initialize(host, key)
      @host = host
      @key = key
    end

    def write(json)
      client.post '/gcm/send', json
    end

    def client
      @_client ||= Faraday.new(host) do |http|
        http.headers['Authorization'] = "key=#{key}"
        http.request :json
        http.adapter :net_http
      end
    end

  end
end
