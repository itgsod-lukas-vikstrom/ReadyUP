class App < Sinatra::Base
  enable :sessions

  get '/' do
    redirect '/index'
  end

  get '/room/:url' do |url|
    @rooms = Room.first(:url => url)
    @hund = RoomUser.all(room_id: @rooms.id)
    @user = User.first(id: @hund.user)
   # @rooms.user[0].time.each do |katt|
   #   katt.split(":")
   #   if Time.new.hour >= katt.to_f && Time.new.min >= katt[1]
   #     puts "YOMOSHOW"
    #end
   # timesplit = params['time'].split(":")

  #end
    slim :room


  end

  get '/index' do
    slim :index
  end

  get '/create' do
    slim :create

  end
  post '/createroom' do
    Room.create(url: rand(36**10).to_s(36), name: params['groupname'], size: params['size'], publicity: params['publicity'], game: params['game'], language: params['language'])
    newroom = Room.first(name: params['groupname'])
    redirect "room/#{newroom.url}"
  end
  get '/browse' do
    @rooms = Room.all
    @kaht = (Room.all).length
    @members = User.all(id: @rooms[0].id).length
    slim :browse

  end
  post '/checkin' do
    User.create(name: params['name'], time: params['time'])
    @dogecoin = User.first(:name => params['name'])
    RoomUser.create(room_id: params['id'], user_id: @dogecoin.id)
    redirect back


  end

end