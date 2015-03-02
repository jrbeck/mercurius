module GCM
  @host = 'https://android.googleapis.com/'
  @key = nil

  class << self
    attr_accessor :host, :key
  end

end
