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
    erb :new
  end
  # get the form/layout of the create new
  # page.

  post '/favorites' do
    sql = "INSERT INTO videos (title, description, url, genre) VALUES ('#{params[:title]}', '#{params[:description]}', '#{params[:url]}', '#{params[:genre]}')"
    run_sql(sql)
    redirect to ('/favorites')
  end
  # now the post pushes the input back to the videos table.  We are going to need some input boxs that corresspond to our :variables

  get '/favorites/:id' do
    sql = "select * from videos where id = #{params[:id]}"
    @favorite = run_sql(sql).first
    erb :show
  end
  # This get is passing a numerical value in the root/url
  # it sets the global value to the first result.  this is funny, 
  # because the the id is supposed to be unique so ofc there is only one.
  # This is a display page, so just one fav is going to show up here.

  get '/favorites/:id/edit' do
    sql = "select * from favorites where id=#{params:id}"
    @favorite = run_sql(sql).first
    erb :edit
  end

  # this is the form for edit like we had for the create new.
  # except this time it calls the item like the display page first.
  # now you can use @favorite to set the old values in the edit box.

  post '/favorites/:id' do
    sql = "UPDATE videos set title = '#{params[:title]}', description = '#{params[:description]}', url = '#{params[:url]}', genre = '#{params[:genre]}' where id = '#{params[:id]}'"
    run_sql(sql)
    redirect to ("/favorites/#{params[:id]}")
  end

  # for the post call(?) we are going to take the values of our input boxes
  # with corresponding :names and update them into the row we selected with our id param 
  # in the where statement.

  delete 'favorites/:id/delete' do
    sql = "DELETE FROM videos WHERE id = '#{params[:id]}'"
    run_sql(sql)
    redirect to ('/items')
  end

  # delete just gets the row id from the url and kills it.

  private

    def run_sql(sql)
      conn = PG.connect(dbname: 'meme_tube', host: 'localhost')
      begin
      conn.exec(sql)
       ensure
      conn.close
    end
  end







