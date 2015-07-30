require 'sinatra'
require 'securerandom'

Redis.current = Redis.new(:host => '127.0.0.1', :port => 6379)

class Name
  include Redis::Objects
end

class HashPoint
  include Redis::Objects
  def id
    SecureRandom.hex
  end
end

post '/h/new' do
  hash = HashPoint.new
  status 303
  headers 'Location' => "/h/#{hash.id}"
end

get '/h/:hash' do |hash|
  "#{name_from(hash)} is name"
end

def name_from(hash)
  "name"
end
