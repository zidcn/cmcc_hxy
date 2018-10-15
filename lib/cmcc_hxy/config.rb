module CmccHxy
  class Config
    attr_accessor :hxy_host

    def initialize
      @hxy_host = "http://223.86.3.124:8081"
    end
  end
end
