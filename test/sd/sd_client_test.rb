require 'test_helper'
require 'net/http'
require 'cmcc_hxy/config'

class SdClientTest < Minitest::Test
  def setup
    key = [-5, 122, 25, -57, -36, -82, 44, 8].pack("c*")
    @client = CmccHxy::SD::Client.new(key: key, cpcode: '419106', sale_modal_id: 'xlxgk10')
    @origin = '<?xml version="1.0" encoding="UTF-8"?><response><ResultCode>1</ResultCode><ResultMessage>token已失效</ResultMessage><ResultList></ResultList></response>'.force_encoding('UTF-8')
  end

  def test_shandong_decrypt_and_encrypt
    assert_equal @origin, @client.decrypt(@client.encrypt(@origin))
  end

  def test_request
    respon = @client.hash_to_xml({"success" => "ok"})
    encode = @client.encrypt(respon)
    stub_request(:post, CmccHxy::Config.hxy_sd_url).to_return(body: Base64.encode64(encode).gsub(/\n/, ''))

    result = @client.request('004', {'SchoolId' => '121', 'ClassId' => '369137'})

    assert_equal result, {'success' => 'ok'}
  end
end

