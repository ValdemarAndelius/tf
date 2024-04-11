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

post('/login') do
    session[:username] = params[:username]
    session[:password] = params[:password]
    p session[:username]
    p session[:password]
    redirect('/login')
end

get('/build') do
    db = SQLite3::Database.new("db/slutprojekt2024.db")
    db.results_as_hash = true
    result = db.execute("SELECT * FROM part")
    slim(:"builds/index",locals:{builds:result})
end

get('/build/new') do
    db = SQLite3::Database.new("db/slutprojekt2024.db")
    db.results_as_hash = true
    @result = db.execute("SELECT * FROM part")
    p @result
    slim(:"builds/new")
end

post('/build/new') do
    title = params[:part]
    part_id = params[:part_id].to_i
    p "Vi fick in datan #{part} #{part_id}"
    db = SQLite3::Database.new("db/slutprojekt2024.db")
    db.execute("INSERT INTO build (part, part_id) VALUES (?,?)", part, part_id)
    redirect('/build')
end

post('/build/:id/delete') do
    id = params[:id].to_i
    db = SQLite3::Database.new("db/slutprojekt2024.db")
    db.execute("DELETE FROM build WHERE build_id = ?",id)
    redirect('/build')
end

post('/albums/:id/update') do
    id = params[:id].to_i
    title = params[:title]
    artist_id = params[:artistId].to_i
    db = SQLite3::Database.new("db/slutprojekt2024.db")
    db.execute("UPDATE build SET name=?,build_id=? WHERE build_id = ?", name,part_id,id) 
    redirect('/build')
end

get('/albums/:id/edit') do
    id = params[:id].to_i
    db = SQLite3::Database.new("db/slutprojekt2024.db")
    db.results_as_hash = true
    result = db.execute("SELECT * FROM build WHERE build_id = ?",id).first
    slim(:'/builds/edit', locals:{result:result})
end

get('/build/:id') do
    id = params[:id].to_i
    db = SQLite3::Database.new("db/slutprojekt2024.db")
    db.results_as_hash = true
    result = db.execute("SELECT * FROM albums WHERE build_id = ?",id).first
    result2 = db.execute("SELECT name FROM part WHERE partid IN (SELECT part_id FROM build WHERE build_id = ?)",id).first
    slim(:"albums/show",locals:{result:result,result2:result2})
end