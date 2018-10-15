require "cmcc_hxy/client"
require "cmcc_hxy/config"
require "cmcc_hxy/version"

module CmccHxy
  class << self
    attr_accessor :config
  end

  self.config ||= Config.new
end
