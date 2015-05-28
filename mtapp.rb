require 'sinatra'
require 'sinatra/reloader' if development?
require 'pg'
require 'pry-byebug'

get '/' do 
  redirect to ('/videos')
  end
  # start by sending them to our list/homepage

  get '/videos' do
    sql = 'select * from videos'
    @videos = run_sql(sql)
    erb :videos
  end
  # now they are on our list page get the list
  # of videos from the videos table.
  # load the erb file videos 

  get '/videos/new' do
    erb :new
  end
  # get the form/layout of the create new
  # page.

  post '/videos' do
    sql = "INSERT INTO videos (title, description, url, genre) VALUES ('#{params[:title]}', '#{params[:description]}', '#{params[:url]}', '#{params[:genre]}')"
    run_sql(sql)
    redirect to ('/videos')
  end
  # now the post pushes the input back to the videos table.  We are going to need some input boxs that corresspond to our :variables

  get '/videos/:id' do
    sql = "select * from videos where id = #{params[:id]}"
    @video = run_sql(sql).first
    erb :show
  end
  # This get is passing a numerical value in the root/url
  # it sets the global value to the first result.  this is funny, 
  # because the the id is supposed to be unique so ofc there is only one.
  # This is a display page, so just one fav is going to show up here.

  get '/videos/:id/edit' do
    sql = "select * from videos where id=#{params:id}"
    @video = run_sql(sql).first
    erb :edit
  end

  # this is the form for edit like we had for the create new.
  # except this time it calls the item like the display page first.
  # now you can use @video to set the old values in the edit box.

  post '/videos/:id' do
    sql = "UPDATE videos set title = '#{params[:title]}', description = '#{params[:description]}', url = '#{params[:url]}', genre = '#{params[:genre]}' where id = '#{params[:id]}'"
    run_sql(sql)
    redirect to ("/videos/#{params[:id]}")
  end

  # for the post call(?) we are going to take the values of our input boxes
  # with corresponding :names and update them into the row we selected with our id param 
  # in the where statement.

  delete '/videos/:id/delete' do
    sql = "DELETE FROM videos WHERE id = '#{params[:id]}'"
    run_sql(sql)
    redirect to ('/videos')
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

# opens a connection to the db and passes the sql as an argument.
# is this how they do sql injections? using arguments to run sql?






