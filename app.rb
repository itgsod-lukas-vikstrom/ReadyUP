class App < Sinatra::Base
  enable :sessions

  get '/' do
    redirect '/browse'
  end

  get '/room/:url' do |url|
    @rooms = Room.first(:url => url)
    @roomusers = RoomUser.all(room_id: @rooms.id)
    @user = User.first(id: @roomusers.user)
    slim :room

  end

  get '/create' do
    slim :create

  end
  post '/createroom' do
    Room.create(url: rand(36**10).to_s(36), name: params['groupname'], size: params['size'], visibility: params['publicity'], game: params['game'], language: params['language'])
    newroom = Room.first(name: params['groupname'])
    redirect "room/#{newroom.url}"
  end
  get '/browse' do

    @rooms = Room.all
    #@members = User.first(id: @roomusers.user).length
    slim :browse

  end
  post '/checkin' do
    User.create(name: params['name'],admin: 't', login_provider: "stum", login_key: "alft4")
    @createduser = User.first(:name => params['name'])
    RoomUser.create(room_id: params['id'], user_id: @createduser.id)

    redirect back


  end
  post 'remove_checking' do

  end
end