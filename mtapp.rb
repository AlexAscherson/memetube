require 'sinatra'
require 'sinatra/reloader' if development?
require 'pg'
require 'pry-byebug'

get '/' do 
  redirect to ('/favorites')
  end
  # start by sending them to out list

  get '/favorites' do
    sql = 'select * from videos'
    @videos = run_sql(sql)
    erb :favorites
  end
  # now they are on our list page get the list
  # of favorites from the videos table.
  # load the erb file favorites 

  get '/favorites/new' do
    erb:new
  end
  # get the form/layout of the create new
  # page.

  post '/favorites' do
    sql = "INSERT INTO videos (title, description, url, genre) VALUES ('#{params[:title]}', '#{params[:description]}', '#{params[:url]}', '#{params[:genre]}')