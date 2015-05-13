
  $channels = {}
  $ids_in_room = {}
  $id_to_name = {}
  $id_to_sessid = {}
  $sessionid_to_room ={}
  $main_channel = EM::Channel.new
  $chat_online = false
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
      redirect_url = User.login(env['omniauth.auth'], 'steam', self)
      redirect redirect_url ||= back
    end

    get '/auth/google_oauth2/callback' do
      redirect_url = User.login(env['omniauth.auth'], 'google', self)
      redirect redirect_url ||= back
    end

    get '/auth/facebook/callback' do
      redirect_url = User.login(env['omniauth.auth'], 'facebook', self)
      redirect redirect_url ||= back
    end

    get '/auth/failure' do
      flash[:error] = "Authentication failed. Please contact administrators."
      params[:message]
    end

    get '/logout' do
      User.logout(self)
      redirect back
    end

    get '/' do
      redirect '/home'
    end

    get '/room/:url' do |url|
      if $chat_online == false
        chat
      end
      unless Room.first(:url => url)
        flash[:error] = "Room does not exist."
        redirect "/browse"
      end
      if $channels.fetch(url) { nil} == nil
        $channels[url] = EM::Channel.new
      end
      session[:room] = url
      $usersroom = session[:room]
      $loginkey = session[:login_key]
      @url = url
      @room = Room.first(:url => url) #hämtar informationen om rummet
      @users = @room.user
      @user= User.first(login_key: session[:login_key])
      $name = @user.alias if @user != nil
      @amountofusers = 0
      @users.each do |person|
        (RoomUser.first(user_id: person.id, room_id: @room.id)).check_time
      end
      slim :room
    end

    post '/createroom' do

      redirect_url = Room.build(params, self)
      redirect redirect_url ||= back
    end

    get '/home' do
      @admin = session[:admin]

      @home = TRUE
      @games = Game.all
      @rooms = Room.all
      @user = User.first(login_key: session[:login_key])
      $name = @user.alias if @user != nil
      @languages = ["Albanian","Arabic","Armenian","Bosnian","Bulgarian","Chinese","Croatian","Czech","Danish","Dutch","Estonian","English","Finnish","French","Georgian","German","Greek","Hindi","Hungarian","Icelandic","Indonesian","Irish","Italian","Japanese","Korean","Indonesian","Mandarin","Persian","Polish","Portuguese","Punjabi","Russian","Spanish","Swedish","Thai","Turkish","Ukrainan","Vietnamese"]
      slim :main
    end

    post '/room/checkin/:url' do |url|
      puts "JODPAWJDOWAPDADWD"
      room = Room.first(url: url)
      $usersroom = session[:room]

      redirect_url = RoomUser.checkin(params, url, self)
      @room_user = RoomUser.first(room_id: room.id, user_id: (User.first(login_key: session[:login_key])).id)
=begin
      @room_user.timezone_offset
=end
      redirect redirect_url ||= back
    end

    get '/room/checkout/:url' do |url|
      RoomUser.checkout(url, self)
      redirect redirect_url ||= back
    end

    post '/sendreport' do
      user = User.first(alias: params['reportname'])
      Report.create(comment: params['reportdescription'], user_id: user.id)
      redirect back
    end

    get '/alias' do
      if session[:member] == true
        $name = session[:alias]
        slim :alias
      else redirect '/home'
        flash[:info] = "Please sign in before changing your alias."
      end
    end

    post '/createalias' do
      User.changealias(params, self)
     redirect back
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

    post '/change_audio/:id' do |id|
      @room = Room.first(id: id)
      @room.change_audio(params, self)
      redirect back
    end
    post '/change_background/:id' do |id|
      @room = Room.first(id: id)
      @room.change_background(params, self)
      redirect back
    end

    post '/removeroom/:id' do |id|
      protected!
      RoomUser.remove_room(id,self)
      redirect back
    end

    post '/sendviolation' do
      Violation.send_violation(params)
      redirect back
    end

    get '/room/:room_url/users.json' do |room_url|
      @room = Room.first(url: room_url)
      return JSON.generate(@room.users)
    end

    get '/admin' do
      protected!
      slim :admin
    end

  end
def chat
  EventMachine::WebSocket.start(:host => '0.0.0.0', :port => 2000,:debug => true) do |ws|
    $chat_online = true
    if $name
      ws.onopen {
=begin //Alpha version of attempt to fix multiple tab related bugs
        if $sessionid_to_room.has_key?($loginkey) == true && $sessionid_to_room.has_value?($usersroom) == true
          p "_________x___________"
          $channels[("#{$ids_in_room.fetch($id_to_sessid.key($loginkey))}")].unsubscribe($id_to_sessid.key($loginkey))
          p $channels[("#{$ids_in_room.fetch($id_to_sessid.key($loginkey))}")]
        end
=end
        mainchannel_id = $main_channel.subscribe{ |msg| ws.send msg }
        $ids_in_room[mainchannel_id] = "#{$usersroom}"
        $id_to_name[mainchannel_id] = "#{$name}"
        $id_to_sessid[mainchannel_id] = "#{$loginkey}"
        $sessionid_to_room[$id_to_sessid[mainchannel_id]] = $ids_in_room[mainchannel_id] = "#{$usersroom}"
        name = "#{$id_to_name.fetch(mainchannel_id)}"
        id = $channels[("#{$ids_in_room.fetch(mainchannel_id)}")].subscribe{ |msg| ws.send msg }
        if RoomUser.first(user_id: (User.first(login_key: $id_to_sessid.fetch(mainchannel_id){}).id), room_id: (Room.first(url: $ids_in_room.fetch(mainchannel_id)).id))
          $channels[("#{$ids_in_room.fetch(mainchannel_id)}")].push "#{name} Checked in"
        end

        ws.onmessage { |msg|
          if $channels[("#{$ids_in_room.fetch(mainchannel_id)}")]
           $channels[("#{$ids_in_room.fetch(mainchannel_id)}")].push "#{$id_to_name.fetch(mainchannel_id)}:" + " #{msg}"
          File.open("#{$ids_in_room.fetch(mainchannel_id)}" + ".txt", 'a') do |file|
            #count = %x{wc -l #{file}}.split.first.to_i
            file.write "\n"
            file.write "#{$id_to_name.fetch(mainchannel_id)}" + " | " + "#{$id_to_sessid.fetch(mainchannel_id)}" + " | " + "#{Time.now}" + " | " +"#{msg}"
            end
          end
        }

        if RoomUser.first(user_id: (User.first(login_key: $id_to_sessid.fetch(mainchannel_id)).id), room_id: (Room.first(url: $ids_in_room.fetch(mainchannel_id)).id))
          ws.onclose {
            $channels[("#{$ids_in_room.fetch(mainchannel_id)}")].push "#{$id_to_name.fetch(mainchannel_id)} Checked out"
            userroom = RoomUser.first(user_id: (User.first(login_key: $id_to_sessid.fetch(mainchannel_id)).id), room_id: (Room.first(url: $ids_in_room.fetch(mainchannel_id)).id))
            userroom.destroy! if userroom != nil
            $channels[("#{$ids_in_room.fetch(mainchannel_id)}")].unsubscribe(id)
            $main_channel.unsubscribe(mainchannel_id)
            $sessionid_to_room.delete($id_to_sessid[mainchannel_id])

          }
        end
      }
    end

  end
end