class CmccHxy::Config
  class << self
    attr_accessor :hxy_host_sc, :hxy_sms_host_sc, :hxy_sd_url
  end

  self.hxy_host_sc = "http://223.86.3.124:8081"
  self.hxy_sms_host_sc = "http://223.86.3.124:8082"
  self.hxy_sd_url = "http://223.99.248.4:7098/httpService"
end
