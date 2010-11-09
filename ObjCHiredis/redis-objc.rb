# redis.rb
# ObjCHiredis
#
# Created by Louis-Philippe on 10-11-02.
# Copyright 2010 Modul. All rights reserved.

# A wrapper for the ObjCHiredis framework mimicking the redis-rb gem

class ObjCHiredis

  # class methods
  
  def self.redis_rb(opts=nil)
        if opts.nil?
          ObjCHiredis.redis
        else
          # redis = Redis.new(:host => host, :port => port, :thread_safe => true, :db => db)
          # db option?
          ObjCHiredis.redis(opts[:host], on:opts[:port])
        end
      end
  
  # Most methods will fit in here
  def method_missing(meth_symbol, *args)
    self.command("#{meth_symbol.to_s.upcase} #{args.join(' ')}")
  end
  
  # the ones that don't
  
  def [](key)
    self.command("GET #{key}")
  end
  
  def []=(key, value)
    self.command("SET #{key} #{value}")
  end

end
