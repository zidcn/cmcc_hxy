require "test_helper"

class SmsClientTest < Minitest::Test
  def setup
    @sms_client = CmccHxy::SmsClient.new("appid")
  end

  def test_sys_send_sms
    stub_request(:post, /SYS_SEND_SMS_BYMOBILE/)
      .to_return(status: 200, body: {"smssn"=>"smssn"}.to_json)
    result = @sms_client.sys_send_sms(sendmobile: "sendmobile",
                                      smscontent: "smscontent",
                                      phones: ["phone"])

    assert_equal result, {"smssn"=>"smssn"}
  end

  def test_qry_sms_result
    stub_request(:post, /QRY_SMS_RESULT/)
      .to_return(status: 200, body: {"smssn"=>"smssn"}.to_json)
    result = @sms_client.qry_sms_result("smssn")

    assert_equal result, {"smssn"=>"smssn"}
  end
end
