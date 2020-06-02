require 'json'
require 'rest-client'
require 'cmcc_hxy/error'

class CmccHxy::RestClient
  def initialize(method, url, params)
    @method, @url, @params = method, url, params
  end

  def request
    response = RestClient::Request.execute(method: @method, url: @url, headers: {params: @params})
    result = JSON.parse(response)
  rescue JSON::ParserError
    raise CmccHxy::Error.new("移动和校园 JSON 解析出错")
  rescue RestClient::ExceptionWithResponse => e
    raise CmccHxy::Error.new("移动和校园请求出错 #{e.response.code}")
  else
    if response.code == 200 && result.is_a?(Hash) && result.key?('error_code')
      raise CmccHxy::Error.new(result.fetch('error_msg'))
    end

    result
  end
end
