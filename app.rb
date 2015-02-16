class App < Sinatra::Base
  enable :sessions
  require 'pp'

  use OmniAuth::Builder do
    provider :steam, '7086038880F2FF8DEA78BB990C3FCB3C'
    provider :google_oauth2, '643100737378-kemmav0q39h9bg1t2t0v8r3n0gc60isd.apps.googleusercontent.com', 'hPvsDKRvLAmnd0QcCuz5udAj',
             {
                 :image_size => 30
             }
    provider :facebook, '746174555501363', 'b50af27608013d97dea2035b0e444bde'
    {
        :image_size => 30
    }
  end

  helpers do
    def member?
      session[:member]
    end
  end

  get '/public' do
    "This is the public page - everybody is welcome!"
  end

  get '/private' do
    halt(401,'Not Authorized') unless member?
    "This is the private page - members only"
  end

  get '/login/:login_provider' do |login_provider|
    redirect to("/auth/steam") if session[:member] == nil && login_provider == 'steam'
    redirect to("/auth/google_oauth2") if session[:member] == nil && login_provider == 'google'
    redirect to("/auth/facebook") if session[:member] == nil && login_provider == 'facebook'
    redirect back
  end

  post '/auth/steam/callback' do


    env['omniauth.auth'] ? session[:member] = true : halt(401,'Not Authorized')
    if User.first(login_key: env['omniauth.auth']['uid']).nil?
      User.create(name: env['omniauth.auth']['info']['nickname'], admin: FALSE, login_provider: 'Steam', login_key: env['omniauth.auth']['uid'], avatar: env['omniauth.auth']['extra']['raw_info']['avatar'])
    end
    user = User.first(login_key: env['omniauth.auth']['uid'])
    if user.banned?
      session[:member] = nil
      redirect '/banned'
    end

    session[:name] = env['omniauth.auth']['info']['nickname']
    session[:login_key] = env['omniauth.auth']['uid']
    session[:avatar] = env['omniauth.auth']['extra']['raw_info']['avatar']
    session[:member] = true
    redirect '/login/steam'
  end

  get '/auth/google_oauth2/callback' do
    env['omniauth.auth'] ? session[:member] = true : halt(401,'Not Authorized')
    pp(env['omniauth.auth'])
    if User.first(login_key: env['omniauth.auth']['uid']).nil?
      User.create(name: env['omniauth.auth']['info']['first_name'], admin: FALSE, login_provider: 'Google', login_key: env['omniauth.auth']['uid'], avatar: '/img/google_logo.png')
    end
    user = User.first(login_key: env['omniauth.auth']['uid'])
    if user.banned?
      session[:member] = nil
      redirect '/banned'
    end
    session[:name] = env['omniauth.auth']['info']['first_name']
    session[:login_key] = env['omniauth.auth']['uid']
    session[:avatar] = '/img/google_logo.png'
    session[:member] = true
    redirect '/login/google'
  end

  get '/auth/facebook/callback' do
    env['omniauth.auth'] ? session[:member] = true : halt(401,'Not Authorized')
    if User.first(login_key: env['omniauth.auth']['extra']['raw_info']['id']).nil?
      User.create(name: env['omniauth.auth']['info']['first_name'], admin: FALSE, login_provider: 'Facebook', login_key: env['omniauth.auth']['extra']['raw_info']['id'], avatar: '/img/fb_logo.png')
    end
    user = User.first(login_key: env['omniauth.auth']['uid'])
    if user.banned?
      session[:member] = nil
      redirect '/banned'
    end
    session[:name] = env['omniauth.auth']['info']['first_name']
    session[:login_key] = env['omniauth.auth']['extra']['raw_info']['id']
    session[:avatar] = '/img/fb_logo.png'
    session[:member] = true
    redirect '/login/facebook'
  end

  get '/auth/failure' do
    params[:message]
  end

  get '/logout' do
    RoomUser.all(user_id: (User.first(login_key: session[:login_key])).id).destroy
    session.clear
    redirect back
  end

  get '/' do
    redirect '/browse'
  end

  get '/room/:url' do |url|
    @room = Room.first(:url => url) #hämtar informationen om rummet
    @users = @room.user
    @name = session[:name]
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
      RoomUser.create(room_id: params['id'], user_id: (User.first(login_key: session[:login_key])).id, leader: TRUE, ready_until: time)
      @user = RoomUser.first(room_id: params['id'], user_id: (User.first(login_key: session[:login_key])).id)
      if @user.ready_until < DateTime.now
        @user.update(ready_until: (@user.ready_until) + 1)
      end
      redirect back
    else redirect '/error'

    end
  end

  post '/checkout' do
    @room = Room.first(id: params['id'])
    RoomUser.first(user: User.first(login_key: session[:login_key]), room: @room).destroy
    redirect back
  end

  post '/sendreport' do
    user = User.first(name: params['reportname'])
    Report.create(comment: params['reportdescription'], user_id: user.id)
    redirect back
  end



  error do
    raise "ERROR!!!!!!"
  end

  get '/reports' do
    user = User.first(login_key: session[:login_key])
    @reports = Report.all
    if session[:login_key] != nil && user.admin == true
      slim :report
    else redirect '/error'
    end

  end

  post '/removereport' do
    p params['hidden']
    Report.first(id: params['id']).destroy
    redirect back

  end

  post '/sendviolation' do
    Violation.create(end_date: params['date'],user_id: params['userid'])
    Report.first(id: params['id']).destroy
    redirect back
  end

end