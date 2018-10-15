require "test_helper"
require "minitest/mock"

class CmccHxyTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::CmccHxy::VERSION
  end
end
