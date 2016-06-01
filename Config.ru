require_relative 'public/racker.rb'
use Rack::Static, urls: ["/public"]
run Racker.new