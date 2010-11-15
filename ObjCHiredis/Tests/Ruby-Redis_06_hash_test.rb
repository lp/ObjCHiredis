# Ruby-Redis_06_hash_test.rb
# ObjCHiredis
#
# Created by Louis-Philippe on 10-11-11.
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
    @redis.close
  end
  
  def test_01_hset
	retVal = @redis.hset("myhash","myfield","myvalue")
	assert_instance_of Fixnum, retVal
	assert_equal 1, retVal
	end
	
  
end