framework 'ObjCHiredis'
require ObjCHiredis.rb
require 'test/unit'

class InitTest < Test::Unit::TestCase
  def setup
    @redis = ObjCHiredis.redisRb
  end
  
  def teardown
    @redis.flushdb
    @redis.close
  end
  
  def test_01_reality
    assert_equal 2, 2
  end
  
  def test_02_init
    assert_instance_of ObjCHiredis, @redis
  end
  
  def test_03_init_with_options
    tempRedis = ObjCHiredis.redisRb(:host => "127.0.0.1", :port => 6379)
    assert_instance_of ObjCHiredis, tempRedis
    tempRedis.quit
  end
  
  def test_04_exists
    assert_equal 0, @redis.exists( "dummykey")
    @redis.set("MYKEY", "MYVALUE")
    assert_equal 1, @redis.exists( "MYKEY")
  end
  
  def test_05_del
    assert_equal 0, @redis.del( "dummyKey")
    @redis.set("MYKEY", "MYVALUE")
    assert_equal 1, @redis.del( "MYKEY")
  end
  
  def test_08_randomkey
    assert_equal nil, @redis.randomkey
    keys = ["key1", "key2", "key3"]
    keys.each { |key| @redis.set(key, "anyValue") }
    rankey = @redis.randomkey
    assert_instance_of String, rankey
    assert_equal true, keys.include?(rankey)
  end
  
end