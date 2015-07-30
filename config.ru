require "rubygems"
require "bundler"
Bundler.require

# require 'rack-livereload'
# use Rack::LiveReload
# using 'rerun rackup' or 'rerun thin start'
# http://www.sinatrarb.com/faq.html#reloading

require "./app/app"
run Sinatra::Application
