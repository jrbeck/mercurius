class FakeSocket < StringIO
  attr_reader :wrote

  def initialize(*)
    @_open = false
    super
  end

  def write(data)
    @wrote ||= []
    @wrote << data
    super
  end

  def read
  end

  def connect
    @_open = true
  end

  def close
    @_open = false
  end

  def closed?
    @_open == false
  end
end
