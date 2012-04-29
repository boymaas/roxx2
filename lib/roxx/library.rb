class Library < Hash
  class SoundNotFound < StandardError; end


  alias :set :[]=

  def fetch(*args)
    super
  rescue IndexError => e
    raise SoundNotFound, e
  end
end
