class CmccHxy::Config
  class << self
    attr_accessor :hxy_host, :hxy_sms_host
  end

  self.hxy_host = "http://223.86.3.124:8081"
  self.hxy_sms_host = "http://223.86.3.124:8082"
end
