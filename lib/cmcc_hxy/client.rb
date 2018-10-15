require 'json'
require 'rest-client'
require 'cmcc_hxy/error'

class CmccHxy::Client
  def initialize(token)
    @token = token
  end

  def get_users
    chk_oauth
  end

  def get_order(user_id)
    qry_order(user_id)
  end

  #     第三方应用获取accessToken后调用CHK_OAUTH接口,获取用户信息
  #     http://IP:PORT/typtOauth/typt/chk_oauth?data={accesstoken:"sdfsdf"}
  #
  # 请求:
  #     参数名称                Json参数对       类型       是否比需            描述
  #   --------------------------------------------------------------------------------------------
  #       data =>
  #                             accesstoken     String       是          登录时有开放平台提供
  #
  # 响应:(查询结果json数组)
  #   参数名称                   类型             是否必需                  描述
  #   --------------------------------------------------------------------------------------------
  #     ID                       String              是                     用户ID
  #     NAME                     String              是                     用户姓名，如果是用户手机号则中间4位由*代替
  #     MOBILE                   String              是                     用户手机号
  #     ROLE                     String              是                     1：学生  2：家长 3：老师 4：管理员
  #     STUNUM                   String              是                     学号
  #     CLASSID                  String              是                     班级ID
  #     GRADEID                  String              是                     年级ID
  #     SCHOOLID                 String              是                     学校ID
  #     COUNTYID                 String              是                     区县ID
  #     CITYID                   String              是                     地市ID
  #     ONLY_ID                  String              是                     对应启迪用户ID
  def chk_oauth
    params = {
      data: "{accesstoken: #{@token}}"
    }
    request("#{CmccHxy.config.hxy_host}/typtOauth/typt/chk_oauth", {params: params})
  end

  #     第三方应用调用此接口查询业务的开通情况.第三方应用只能查询到有关自己的业务开通情况。
  #     http://IP:PORT/typtOauth/typt/qry_order?data={accesstoken:"sdfsdf",userid: "12321"}
  #
  # 请求:
  #    参数名称                   类型             是否比需                  描述
  #   --------------------------------------------------------------------------------------------
  #     accesstoken             String              是
  #     userid                  String              是
  #
  # 响应:
  #   参数名称                   类型             是否必需                  描述
  #   --------------------------------------------------------------------------------------------
  #     userid                  String              是
  #     apps =>
  #           appid             int                                       应用ID
  #           appname           String                                    应用名称
  #           applifecycle      int                                       0体验期 1正式期
  #           servicesid        String                                    业务ID
  #           servicename       String                                    业务名称
  #           fee               Float                                     费用
  #           feetype           int                                       0:一次性 1:包月 2:包年
  #           createtime        String                                    订购时间
  #           begintime         String                                    订购时间
  #           endtime           String                                    订购时间
  def qry_order(uid)
    params = {
      data: "{accesstoken:#{@token}, userid:#{uid}}"
    }
    request("#{CmccHxy.config.hxy_host}/typtOauth/typt/qry_order", {params: params})
  end

  private

  def request(url, params)
    begin
      response = RestClient.get(url, params)
      result = JSON.parse(response)
    rescue JSON::ParserError
      raise CmccHxy::Error.new("移动和校园 JSON 解析出错")
    rescue RestClient::ExceptionWithResponse => e
      raise CmccHxy::Error.new("移动和校园请求出错 #{e.response.code}")
    end

    if response.code == 200 && result.is_a?(Hash) && result.key?('error_code')
      raise CmccHxy::Error.new(result.fetch('error_msg'))
    end

    result
  end
end
