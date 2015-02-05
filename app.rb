class App < Sinatra::Base
  enable :sessions

  use OmniAuth::Builder do
    provider :steam, "7086038880F2FF8DEA78BB990C3FCB3C"
  end

  get '/' do
    redirect '/browse'
  end

  get '/room/:url' do |url|
    @room = Room.first(:url => url) #hämtar informationen om rummet
    @roomusers = RoomUser.all(room_id: @room.id) #hämtar id på alla som har checkat in i det rummet.
    @users = @room.user

    slim :room

  end

  get '/create' do
    slim :create

  end
  post '/createroom' do
    Room.create(url: rand(36**10).to_s(36), name: params['groupname'],#skapar ett slumpmässigt token som URL
                size: params['size'], public: params['publicity'],
                game: params['game'], language: params['language'])
    newroom = Room.first(name: params['groupname'])
    redirect "room/#{newroom.url}"
  end
  get '/browse' do
    @rooms = Room.all
    slim :browse

  end
  post '/checkin' do
    @room = Room.first(id: params['id'])

    if @room.user.length < @room.size
      time = params['hour'] + ':' + params['minute']
      User.create(name: params['name'],admin: 'false', login_provider: "", login_key: "", time: time)
      @createduser = User.first(:name => params['name'])
      RoomUser.create(room_id: params['id'], user_id: @createduser.id)
      redirect back
    else redirect '/error'

    end
  end

  post 'remove_checking' do

  end

  post ":room_id/auth/steam/callback" do |room_id|
    @steam_info = request.env["omniauth.auth"]
    @room_id = room_id
    redirect '/login'
  end

  error do
    raise "ERROR!!!!!!"
  end

end