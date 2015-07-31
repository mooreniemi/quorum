require 'sinatra'
require 'securerandom'

Redis.current = Redis.new(:host => '127.0.0.1', :port => 6379)

class NameSpace
  attr_accessor :name
  def initialize(name = nil)
    @name = name.id
  end
  def attach(hashpoint)
    Redis.current.sadd(name, hashpoint.id)
  end
  def attached
    Redis.current.smembers(name)
  end
end

class Name
  include Redis::Objects
  def id
    #human readable word IS 'primary' key
    @id ||= [*('A'..'Z')].sample(8).join
  end
  value :hash_point
end

class HashPoint
  include Redis::Objects
  def id
    @id ||= SecureRandom.hex
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
  end
end
