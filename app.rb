class App < Sinatra::Base
  enable :sessions

  use OmniAuth::Builder do
    provider :steam, '7086038880F2FF8DEA78BB990C3FCB3C'
  end

  use Warden::Manager do |config|
    config.serialize_into_session{|user| user.id }
    config.serialize_from_session{|id| User.get(id) }
    config.scope_defaults :default,
                          strategies: [:auth],
                          action: 'auth/unauthenticated'
    config.failure_app = self
  end

  Warden::Manager.before_failure do |env, opts|
    env['REQUEST_METHOD'] = 'POST'
  end

  Warden::Strategies.add(:auth) do

    def authenticate!
      user = User.first(login_key: @steam_info.uid)

      if user.nil?
        puts "FAILED"
        fail!("The user does not exist.")
      elsif user.authenticate(@steam_info.uid)
        success!(user)
        puts "SUCCESS MOTHERFUCKER"
      else
        puts "FAILED"
        fail!("Could not log in")
      end
    end
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
      User.create(name: params['name'],admin: 'false', login_provider: "", login_key: "", )
      @createduser = User.first(:name => params['name'])
      RoomUser.create(room_id: params['id'], user_id: @createduser.id,leader: TRUE, ready_until: time)
      redirect back
    else redirect '/error'

    end
  end

  post '/remove_checkin' do

  end

  post "/auth/steam/callback" do
    @steam_info = request.env["omniauth.auth"]
    if User.first(login_key: @steam_info.uid).nil?
      User.create(name: @steam_info['info'].nickname, admin: 'f', login_provider: 'Steam', login_key: @steam_info.uid)
    end
    env['warden'].authenticate!
    redirect '/browse' #'/auth/login'
  end

  error do
    raise "ERROR!!!!!!"
  end

end