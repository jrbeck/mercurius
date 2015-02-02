class PemNotFoundError < StandardError

  def initialize
    super 'The specified PEM file does not exist.'
  end

end