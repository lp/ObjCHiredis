framework 'ObjCHiredis'
require ObjCHiredis.rb
require 'test/unit'

class StringTest < Test::Unit::TestCase
  def setup
    @redis = ObjCHiredis.redisRb
  end
  
  def teardown
    @redis.flushdb
    @redis.quit
  end
  
  def test_01_rubyHash
    assert_equal "myvalue", @redis[:mykey] = "myvalue"
    assert_equal 1, @redis.exists("mykey")
    assert_equal "myvalue", @redis[:mykey]
  end
  
end