class App < Sinatra::Base
  enable :sessions

  get '/' do
    redirect '/browse'
  end

  get '/room/:url' do |url|
    @rooms = Room.first(:url => url) #hämtar informationen om rummet
    @roomusers = RoomUser.all(room_id: @rooms.id) #hämtar id på alla som har checkat in i det rummet.
    @users = @rooms.user

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
    @rooms = Room.first(id: params['id'])

    if @rooms.user.length < @rooms.size
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
  error do
    raise "ERROR!!!!!!"
  end

end