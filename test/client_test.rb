require "test_helper"

class ClientTest < Minitest::Test
  def setup
    @client = CmccHxy::Client.new("token")
  end

  def test_get_users
    stub_request(:get, /chk_oauth/)
      .to_return(status: 200, body: {"id"=>"id"}.to_json)
    result = @client.get_users

    assert_equal result, {"id"=>"id"}
  end

  def test_get_order
    stub_request(:get, /qry_order/)
      .to_return(status: 200, body: {"userid"=>"userid"}.to_json)
    result = @client.get_order("userid")

    assert_equal result, {"userid"=>"userid"}
  end
end
