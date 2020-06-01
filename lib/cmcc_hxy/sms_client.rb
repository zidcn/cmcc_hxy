require 'cmcc_hxy/rest_client'
require 'cmcc_hxy/config'

class CmccHxy::SmsClient
  def initialize(appid)
    @appid = appid
  end

  # 接口权限：系统接口，需要分配IP鉴权才能调用
  # MsgType：SYS_SEND_SMS_BYMOBILE
  # 接口地址：http:// IP:PORT /typtInterface/interface/SmsSendServlet
  #
  # 请求：第三方应用–>开放平台
  # 参数名称            类型    是否必需    描述
  # ---------------------------------------------------------------
  # appid            String     是     第三方应用ID
  # sendmobile       String     是     发送人手机号
  # smstype          int        是     0:系统 1考勤 2通知 3 消费
  # smscontent       String     是     短信内容
  # receivermobile   String     是     接收人手机号
  # receivers        [{"receivermobile": receivermobile}]
  #
  # 响应：开放平台–>第三方应用
  # 参数名称           类型    是否必需    描述
  # ---------------------------------------------------------------
  # smssn            String     是     短信标示唯一码（用于短信报告查询）
  def sys_send_sms(smstype: 0, sendmobile:, smscontent:, phones:)
    params = {
      MsgType: "SYS_SEND_SMS_BYMOBILE",
      Data: {
        appid: @appid,
        smstype: smstype,
        sendmobile: sendmobile,
        smscontent: smscontent,
        receivers: phones.map { |phone| {receivermobile: phone} }
      }.to_json
    }

    CmccHxy::RestClient.new(:post, url, params).request
  end

  # 接口权限：系统接口，需要分配权限才能调用
  # MsgType：QRY_SMS_RESULT
  # 接口地址：http:// IP:PORT /typtInterface/interface/SmsSendServlet
  #
  # 请求：第三方应用–>开放平台
  # 参数名称           类型    是否必需     描述
  # ---------------------------------------------------------------
  # smssn            String    是      短信标示唯一码（用于短信报告查询）
  #
  # 响应：开放平台–>第三方应用
  # 参数名称           类型    是否必需     描述
  # ---------------------------------------------------------------
  # smssn            String    是      短信标示唯一码（用于短信报告查询）
  # sendid           int       是      发送人ID
  # sendmobile       String            发送人手机号
  # username         String            发送人姓名
  # sendcount        Int               接收人条数
  # sendtime         String            发送时间
  # sends
  # receiverid       Int       是      接收人ID
  # receivermobile   String    是      接收人手机号
  # receivername     String            接收人姓名
  # ismgstatus       String            状态报告状态
  # rpttime          String            状态报告时间
  def qry_sms_result(smssn)
    params = {
      MsgType: "QRY_SMS_RESULT",
      Data: {appid: @appid, smssn: smssn}.to_json
    }

    CmccHxy::RestClient.new(:post, url, params).request
  end

  private

  def url
    @url ||= "#{CmccHxy::Config.hxy_sms_host}/typtInterface/sms/smsSend"
  end
end
