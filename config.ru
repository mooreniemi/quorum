require "rubygems"
require "bundler"
Bundler.require

require 'rack-livereload'
use Rack::LiveReload

require "./app/app"
run Sinatra::Application
