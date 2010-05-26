require 'rubygems'
require 'sinatra'

require 'flickr'
 
get '/' do
  @photos = Flickr::User.new('fronx').photos
  erb :index
end