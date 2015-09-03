class PemNotConfiguredError < StandardError
  def initialize
    super 'PEM is not configured properly.'
  end
end
