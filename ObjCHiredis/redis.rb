# redis.rb
# ObjCHiredis
#
# Created by Louis-Philippe on 10-11-02.
# Copyright 2010 Modul. All rights reserved.

# A wrapper for the ObjCHiredis framework mimicking the redis-rb gem
framework "ObjCHiredis"
class Redis

  # class methods
  
  def initialize(opts=nil)
    if opts.nil?
      @hiredis = ObjCHiredis.redis
    else
      # redis = Redis.new(:host => host, :port => port, :thread_safe => true, :db => db)
      # db option?
      # @hiredis = ObjCHiredis.alloc.init
      #       host = opts[:host]
      #       port = opts[:port]
      #       @hiredis.connect(host, on:port)
      @hiredis = ObjCHiredis.redis("127.0.0.1", on:6379)
    end
  end
  

end
