# Ruby-Redis_07_pubsub_test.rb
# ObjCHiredis
#
# Created by Louis-Philippe on 10-11-16.
# Copyright 2010 Modul. All rights reserved.

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
  
  def test_01_pubsub
    retVal = @redis.subscribe "channelZ"
    assert_instance_of Array, retVal
    assert_equal "subscribe", retVal[0]
    assert_equal "channelZ", retVal[1]
    assert_equal 1, retVal[2]
    
    NSThread.detachNewThreadSelector("publishSome", toTarget:self, withObject:nil)
    
    retVal = @redis.getReply
    assert_instance_of Array, retVal
    assert_equal "message", retVal[0]
    assert_equal "channelZ", retVal[1]
    assert_equal "GOMAMA!", retVal[2]
  end
  
  def publishSome
    redisT = ObjCHiredis.redisRb
    sleep 1
    redisT.publish "channelZ", "GOMAMA!"
    redisT.quit
    NSThread.exit
  end
  
  
end
