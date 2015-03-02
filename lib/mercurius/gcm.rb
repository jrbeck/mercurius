module GCM
  @host = 'https://android.googleapis.com/'
  @key = ENV['GCM_KEY']

  class << self
    attr_accessor :host, :key
  end

end
