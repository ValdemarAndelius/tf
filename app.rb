require 'sinatra'
require 'sinatra/reloader'
require 'slim'
require 'sqlite3'
require 'bcrypt'

enable :sessions

get('/')  do

    slim(:start)
end 

get ('/login') do
    @username = session[:username]
    @password = session[:password]
    slim(:login)
end