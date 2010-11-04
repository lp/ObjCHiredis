# redis.rb
# ObjCHiredis
#
# Created by Louis-Philippe on 10-11-02.
# Copyright 2010 Modul. All rights reserved.

# A wrapper for the ObjCHiredis framework mimicking the redis-rb gem
framework "/Users/lpperron/Documents/lllaptop/git_repos/Redis/ObjCHiredis/ObjCHiredis/build/Debug/ObjCHiredis.framework"

class Redis

  # class methods
  
  def initialize(opts=nil)
    if opts.nil?
      @hiredis = ObjCHiredis.redis
    else
      # redis = Redis.new(:host => host, :port => port, :thread_safe => true, :db => db)
      # db option?
      @hiredis = ObjCHiredis.redis(opts[:host], on:opts[:port])
    end
  end
  

end
