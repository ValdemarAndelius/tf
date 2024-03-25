require 'sinatra'
require 'sinatra/reloader'
require 'slim'
require 'sqlite3'
require 'bcrypt'

enable :sessions

get('/')  do

    slim(:start)
end 

get('/login') do
    @username = session[:username]
    @password = session[:password]
    slim(:login)
end

get('/build') do
    db = SQLite3::Database.new("db/slutprojekt2024.db")
    db.results_as_hash = true
    result = db.execute("SELECT * FROM part")
    slim(:"build/index",locals:{build:result})
end

get('/build/new') do
    slim(:"build/new")
end

post('/build/new') do
    title = params[:part]
    artist_id = params[:part_id].to_i
    p "Vi fick in datan #{part} #{part_id}"
    db = SQLite3::Database.new("db/slutprojekt2024.db")
    db.execute("INSERT INTO build (part, part_id) VALUES (?,?)", part, part_id)
    redirect('/build')
end