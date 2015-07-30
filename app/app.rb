require 'sinatra'
require 'securerandom'

Redis.current = Redis.new(:host => '127.0.0.1', :port => 6379)

class Name
  include Redis::Objects
  def id
    #human readable word IS 'primary' key
    "Name"
  end

  def hash_point
  end
end

class HashPoint
  include Redis::Objects
  def id
    SecureRandom.hex
  end
  # should claim a Name
  def claims
  end
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
    Name.find_by_hash_point(hash)
  end
end
