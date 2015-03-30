EventMachine.run do
  $channels = {}
  $usersroom = "doge"
  $ids_in_room = {}
  $id_to_name = {}
  $main_channel = EM::Channel.new

  class App < Sinatra::Base
    enable :sessions
    require 'rack-flash'
    require 'pp'
    use Rack::Flash

    use OmniAuth::Builder do
      provider :steam, '7086038880F2FF8DEA78BB990C3FCB3C'
      provider :google_oauth2, '643100737378-kemmav0q39h9bg1t2t0v8r3n0gc60isd.apps.googleusercontent.com', 'hPvsDKRvLAmnd0QcCuz5udAj'
      provider :facebook, '746174555501363', 'b50af27608013d97dea2035b0e444bde'
    end

    helpers do
      def member?
        session[:member]
      end

      def admin?
        session[:admin]
      end

      def protected!
        return if authorized?
        halt 401, "Not authorized\n"
      end

      def creator_protected!(creator_id)
        return if creator_authorized?(creator_id)
        halt 401, "Not authorized\n"
      end

      def authorized?
        session[:admin] == true
      end

      def creator_authorized?(creator_id)
        creator_id == session[:login_key] || session[:admin]
      end
    end

    get '/public' do
      "This is the public page - everybody is welcome!"
    end

    get '/private' do
      halt(401,'Not Authorized') unless member? || admin?
      "This is the private page - member: #{session[:member]}, admin: #{session[:admin]}"
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
        User.create(name: env['omniauth.auth']['info']['nickname'], admin: FALSE, login_provider: 'Steam', login_key: env['omniauth.auth']['uid'], avatar: env['omniauth.auth']['extra']['raw_info']['avatar'], alias: env['omniauth.auth']['info']['nickname'])
      end
      user = User.first(login_key: env['omniauth.auth']['uid'])
      if user.banned?
        session[:member] = nil
        flash[:error] = "You are banned. Please contact administrators."
        redirect '/'
      end
      session[:name] = env['omniauth.auth']['info']['nickname']
      session[:alias] = user.alias
      session[:login_key] = env['omniauth.auth']['uid']
      session[:avatar] = env['omniauth.auth']['extra']['raw_info']['avatar']
      session[:member] = true
      session[:admin] = true if user.admin?
      flash[:success] = "You are now logged in."
      redirect '/login/steam'
    end

    get '/auth/google_oauth2/callback' do
      env['omniauth.auth'] ? session[:member] = true : halt(401,'Not Authorized')
      pp(env['omniauth.auth'])
      if User.first(login_key: env['omniauth.auth']['uid']).nil?
        User.create(name: env['omniauth.auth']['info']['first_name'], admin: FALSE, login_provider: 'Google', login_key: env['omniauth.auth']['uid'], avatar: '/img/google_logo.png', alias: env['omniauth.auth']['info']['first_name'])
      end
      user = User.first(login_key: env['omniauth.auth']['uid'])
      if user.banned?
        session[:member] = nil
        flash[:error] = "You are banned. Please contact administrators."
        redirect '/'
      end
      session[:name] = env['omniauth.auth']['info']['first_name']
      session[:alias] = user.alias
      session[:login_key] = env['omniauth.auth']['uid']
      session[:avatar] = '/img/google_logo.png'
      session[:member] = true
      session[:admin] = true if user.admin?
      flash[:success] = "You are now logged in."
      redirect '/login/google'
    end

    get '/auth/facebook/callback' do
      env['omniauth.auth'] ? session[:member] = true : halt(401,'Not Authorized')
      if User.first(login_key: env['omniauth.auth']['extra']['raw_info']['id']).nil?
        User.create(name: env['omniauth.auth']['info']['first_name'], admin: FALSE, login_provider: 'Facebook', login_key: env['omniauth.auth']['extra']['raw_info']['id'], avatar: '/img/facebook_logo.png', alias: env['omniauth.auth']['info']['first_name'])
      end
      user = User.first(login_key: env['omniauth.auth']['uid'])
      if user.banned?
        session[:member] = nil
        flash[:error] = "You are banned. Please contact administrators."
        redirect '/'
      end
      session[:name] = env['omniauth.auth']['info']['first_name']
      session[:alias] = user.alias
      session[:login_key] = env['omniauth.auth']['extra']['raw_info']['id']
      session[:avatar] = '/img/facebook_logo.png'
      session[:member] = true
      session[:admin] = true if user.admin?
      flash[:success] = "You are now logged in."
      redirect '/login/facebook'
    end

    get '/auth/failure' do
      flash[:error] = "Authentication failed. Please contact administrators."
      params[:message]
    end

    get '/logout' do
      RoomUser.all(user_id: (User.first(login_key: session[:login_key])).id).destroy
      session.clear
      flash[:success] = "You are now logged out."
      redirect back
    end

    get '/' do
      redirect '/browse'
    end

    get '/room/:url' do |url|
      if $channels.fetch(url) { nil} == nil
        channelcreation = EM::Channel.new
        $channels[url] = channelcreation
      end
      if Room.first(:url => url) == nil
        flash[:error] = "Room does not exist."
        redirect "/browse"
      end
      $roomurl = url
      $usersroom ||= session[:room]
      $name = session[:alias]
      @room = Room.first(:url => url) #hämtar informationen om rummet
      @users = @room.user
      @user= User.first(login_key: session[:login_key])
      @name = @user.name if @user != nil
      @amountofusers = 0
      slim :room
    end


    get '/create' do
      @games = Game.all
      @languages = ["Albanian","Arabic","Armenian","Bosnian","Bulgarian","Chinese","Croatian","Czech","Danish","Dutch","Estonian","English","Finnish","French","Georgian","German","Greek","Hindi","Hungarian","Icelandic","Indonesian","Irish","Italian","Japanese","Korean","Indonesian","Mandarin","Persian","Polish","Portuguese","Punjabi","Russian","Spanish","Swedish","Thai","Turkish","Ukrainan","Vietnamese"]
      if session[:login_key] == nil
        flash[:error] = "Please log in before creating a room."
        redirect '/'
      else
        slim :create
      end
    end


    post '/createroom' do
      redirect_url = Room.build(params, self)
      redirect redirect_url ||= back
    end

    get '/browse' do
      @rooms = Room.all
      @user = User.first(login_key: session[:login_key])
      if session[:login_key] != nil && @user.admin == true
        @admin = true
      end
      slim :browse
    end

    post '/checkin' do
      room = Room.first(id: params['id'])
      $usersroom = session[:room]
      if room.user.length < room.size
        time = params['hour'] + ':' + params['minute']
        RoomUser.create(room_id: params['id'], user_id: (User.first(login_key: session[:login_key])).id, leader: TRUE, ready_until: time)
        @room_user = RoomUser.first(room_id: params['id'], user_id: (User.first(login_key: session[:login_key])).id)
        @room_user.timezone_offset
        redirect back
      else
        flash[:error] = "Room is full."
        redirect '/'
      end
    end

    post '/checkout' do
      @room = Room.first(id: params['id'])
      RoomUser.first(user: User.first(login_key: session[:login_key]), room: @room).destroy
      redirect back
    end

    # get '/login' do
    #   if session[:login_key] != nil
    #     flash[:info] = "You are already logged in."
    #     redirect '/'
    #   else
    #     flash[:error] = "Please log in before creating a room."
    #     redirect back
    #   end
    # end

    post '/sendreport' do
      user = User.first(alias: params['reportname'])
      Report.create(comment: params['reportdescription'], user_id: user.id)
      redirect back
    end

    get '/alias' do
      if session[:member] == true
        @currentalias = User.first(login_key:session[:login_key])
        slim :alias
      else redirect '/login'
        flash[:info] = "Please log in before changing your alias."
      end
    end

    post '/createalias' do
      @user = (User.first(login_key: session[:login_key]))
      if params['newalias'].length <= 15
        @user.update(alias: params['newalias'])
        session[:alias] = params['newalias']
        redirect back
      else
        flash[:error] = "Invalid alias. Please try again."
        redirect back
      end
    end

    get '/reports' do
      protected!
      @reports = Report.all
      slim :report
    end

    post '/removereport' do
      protected!
      Report.first(id: params['id']).destroy
      redirect back
    end

    get '/room/:room_url/removeplayer/:id' do |room_url, id|
      creator_id = Room.first(url: room_url).creator_id
      creator_protected!(creator_id)
      RoomUser.first(user_id: id).destroy
      redirect back
    end

    post '/removeroom/:id' do |id|
      protected!
      @roomusers = RoomUser.all(room_id: id)
      @roomusers.each do |user|
        User.get(id: user.user_id)
          user.destroy
        end
      Room.first(id: id).destroy
      redirect back
    end

    post '/sendviolation' do
      user = User.first(id: params['userid'])
      user.update(:banned => TRUE)
      Violation.create(reason: params['reason'], user_id: params['userid'])
      Report.first(id: params['id']).destroy
      RoomUser.all(user_id: params['userid']).destroy
      redirect back
    end

    get '/room/:room_url/users.json' do |room_url|
      @room = Room.first(url: room_url)
      return JSON.generate(@room.users)
    end

    get '/banned/:id' do |userid|
      @user = User.first(id: userid)
      @violation = Violation.first(user_id: userid)
      slim :banned
    end

    get '/admin' do
      protected!
      slim :admin
    end

  end
  EventMachine::WebSocket.start(:host => '0.0.0.0', :port => 2000,:debug => true) do |ws|
    if $name != nil
      ws.onopen {
        mainchannel_id = $main_channel.subscribe{ |msg| ws.send msg }
        $ids_in_room[mainchannel_id] = "#{$roomurl}"
        $id_to_name[mainchannel_id] = "#{$name}"
        id = $channels[("#{$ids_in_room.fetch(mainchannel_id)}")].subscribe{ |msg| ws.send msg }


        ws.onmessage { |msg|
          $channels[("#{$ids_in_room.fetch(mainchannel_id)}")].push "#{$id_to_name.fetch(mainchannel_id)}:" + " #{msg}"
        }

        ws.onclose {
          $channels[("#{$ids_in_room.fetch(mainchannel_id)}")].unsubscribe(id)
        }
      }
    end
  end
  DataMapper.finalize
  Thin::Server.start App, '0.0.0.0', 9292
end