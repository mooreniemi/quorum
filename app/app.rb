require 'sinatra'
require 'securerandom'

Redis.current = Redis.new(:host => '127.0.0.1', :port => 6379)

class Name
  include Redis::Objects
  def id
    #human readable word IS 'primary' key
    [*('A'..'Z')].sample(8).join
  end
  # Name.redis.sadd("hash_point:a2c6471b20151256fe41d784631f4fbe", name.id)
  value :hash_point
end

class HashPoint
  include Redis::Objects
  def id
    SecureRandom.hex
  end
  # should claim a Name
  value :claim
  # increment claimers
  # ?
end

post '/h/new' do
  hash = HashPoint.new
  status 303
  headers 'Location' => "/h/#{hash.id}"
end

get '/h/:hash' do |hash|
  "#{Resolver.name_from(hash)} is name"
end

module Resolver
  def self.name_from(hash)
    Name.redis.smembers("hash_point:#{hash}")
  end
end
