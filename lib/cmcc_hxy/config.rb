module CmccHxy
  class Config
    class << self
      attr_accessor :hxy_host
    end

    self.hxy_host = "http://223.86.3.124:8081"
  end
end
