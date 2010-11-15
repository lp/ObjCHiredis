framework 'ObjCHiredis'
require ObjCHiredis.rb
require 'test/unit'

class InitTest < Test::Unit::TestCase
  def setup
    @redis = ObjCHiredis.redisRb
  end
  
  def teardown
    @redis.flushdb
    @redis.quit
  end
  
  def test_01_rpush
    retVal = @redis.rpush("MYLIST", "MYKEY")
    assert_instance_of Fixnum, retVal
    
    assert_equal(1,@redis.llen("MYLIST"), "rpush didn't pushed a new element in the list")
  end
  
  def test_02_lrange
    @redis.rpush("MYLIST", "MYKEY")
    retVal = @redis.lrange "MYLIST", 0, 3
    
    assert_instance_of Array, retVal
    assert_equal("MYKEY", retVal[0])
  end
  
end