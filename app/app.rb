require 'sinatra'
require 'securerandom'
require 'redis-objects'
require 'virtus'

Redis.current = Redis.new(:host => '127.0.0.1', :port => 6379)

class NameSpace
  include Virtus.model
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
  include Virtus.model
  attr_accessor :on_store
  def initialize(attributes = {})
    super
    @on_store = Redis::Value.new(id, marshal: true)
  end
  attribute :id, String, default: lambda {|instance, attribute| "#{instance.class.name.downcase}:#{attribute.name}:#{[*('A'..'Z')].sample(8).join}"}
  def save
    on_store.value = attributes
  end
end

class HashPoint
  include Virtus.model
  include Redis::Objects
  attribute :id, String, default: proc { "hpoint:#{SecureRandom.hex}" }
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
