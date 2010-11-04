require 'test/unit'
require 'redis'

class InitTest < Test::Unit::TestCase
  def setup
    
  end
  
  def teardown
    
  end
  
  def test_01_reality
    assert_equal 2, 2
  end
  
  def test_02_init
    assert_instance_of Redis, Redis.new
  end
  
  def test_03_init_with_options
    assert_instance_of Redis, Redis.new(:host => "127.0.0.1", :port => 6379)
  end
  
end