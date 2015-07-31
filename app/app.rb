require 'sinatra'
require 'securerandom'
require 'redis-objects'
require 'virtus'
require 'active_support'

Redis.current = Redis.new(:host => '127.0.0.1', :port => 6379)

class Name
  include Virtus.model
  include Redis::Objects

  attribute :id, String, default: :unique_name
  attribute :hpoint, String

  def save
    redis.set(id, attributes.except(:id))
  end

  def unique_name
    "name:#{[*('A'..'Z')].sample(8).join}"
  end
end

class HashPoint
  include Virtus.model
  include Redis::Objects

  attribute :id, String, default: proc { "hpoint:#{SecureRandom.hex}" }
end

class NameSpace
  include Virtus.model

  attribute :name, ::Name

  def attach(hashpoint)
    Redis.current.sadd(name.id, hashpoint.id)
    Redis.current.setnx("_hpoint:#{hashpoint.id}", name.id)
  end

  def attached
    Redis.current.smembers(name.id)
  end
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
  def self.name_from(hpoint)
    Redis.current.get("_hpoint:#{hpoint.id}")
  end
end
