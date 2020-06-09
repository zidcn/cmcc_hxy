require 'json'
require 'rest-client'
require 'cmcc_hxy/error'

class CmccHxy::RestClient
  class << self
    def get(url, params)
      request { RestClient.get(url, params) }
    end

    def post(url, params)
      request { RestClient.post(url, params) }
    end

    private

    def request
      response = yield
      result = JSON.parse(response)

      if response.code == 200 && result.is_a?(Hash) && result.key?('error_code')
        raise CmccHxy::Error.new(result.fetch('error_msg'))
      end

      result
    rescue JSON::ParserError
      raise CmccHxy::Error.new("移动和校园 JSON 解析出错")
    rescue RestClient::ExceptionWithResponse => e
      raise CmccHxy::Error.new("移动和校园请求出错 #{e.response.code}")
    end
  end
end
