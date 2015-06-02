require 'dm-validations'

class User
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true
  property :admin, Boolean, :required => true
  property :login_provider, String, :required => true
  property :login_key, Text, :required => true
  property :avatar, Text
  property :alias, Text
  property :banned, Boolean

  has n, :room, :through => :roomusers
  has 1, :report

  validates_length_of :name, :within => 1..25
  validates_with_method :login_provider, :method => :valid_login_provider?
  validates_numericality_of :login_key
  validates_with_method :avatar, :method => :valid_avatar?
  validates_length_of :alias, :within => 1..25

  def valid_login_provider?
    if @login_provider == "Steam" || @login_provider == "Google" || @login_provider == "Facebook"
      return true
    else
      return [false, "Incorrect login provider."]
    end
  end

  def valid_avatar?
    if @avatar.end_with?(".jpg") || @avatar.end_with?(".png")
      return true
    else
      return [false, "Incorrect avatar image."]
    end
  end

  def self.admin?(app)
    if app.session[:login_key] != nil && User.first(login_key: app.session[:login_key]).admin == true
      return true
    end
  end

  def self.login(env, login_provider, app)
    env ? app.session[:member] = true : halt(401,'Not Authorized')
    user = User.fetch_or_create(env, login_provider)
    if user.banned?
      app.session[:member] = nil
      app.flash[:alert] = "You are banned. Please contact administrators."
      redirect_url = '/home'
    elsif login_provider == 'steam'
      app.session[:name] = env['info']['nickname']
      app.session[:login_key] = env['uid']
      app.session[:avatar] = env['extra']['raw_info']['avatar']
      app.session[:alias] = user.alias
      app.session[:member] = true
      app.session[:admin] = true if user.admin?
      app.flash[:success] = "You are now signed in."
      redirect_url = '/login/steam'
    elsif login_provider == 'google'
      app.session[:name] = env['info']['first_name']
      app.session[:login_key] = env['uid']
      app.session[:avatar] = '/img/google_logo.png'
      app.session[:alias] = user.alias
      app.session[:member] = true
      app.session[:admin] = true if user.admin?
      app.flash[:success] = "You are now signed in."
      redirect_url = '/login/google'
    elsif login_provider == 'facebook'
      app.session[:name] = env['info']['first_name']
      app.session[:login_key] = env['extra']['raw_info']['id']
      app.session[:avatar] = '/img/facebook_logo.png'
      app.session[:alias] = user.alias
      app.session[:member] = true
      app.session[:admin] = true if user.admin?
      app.flash[:success] = "You are now signed in."
      redirect_url = '/login/facebook'
    end
    return redirect_url
  end

  def self.fetch_or_create(env, login_provider)
    case login_provider
      when 'steam'
        user = User.first_or_create({login_key: env['uid']},
                                    {name: env['info']['nickname'],
                                    admin: FALSE,
                                    login_provider: 'Steam',
                                    avatar: env['extra']['raw_info']['avatar'],
                                    alias: env['info']['nickname']})
      when 'google'
        user = User.first_or_create({login_key: env['uid']},
                                    {name: env['info']['first_name'],
                                    admin: FALSE,
                                    login_provider: 'Google',
                                    avatar: '/img/google_logo.png',
                                    alias: env['info']['first_name']})
      when 'facebook'
        user = User.first_or_create({login_key: env['extra']['raw_info']['id']},
                                    {name: env['info']['first_name'],
                                    admin: FALSE,
                                    login_provider: 'Facebook',
                                    avatar: '/img/facebook_logo.png',
                                    alias: env['info']['first_name']})
    end
    return user
  end

  def in_room?(room)
    RoomUser.first(room_id: room.id, user_id: self.id)
  end

  def self.logout(app)
    RoomUser.all(user_id: (User.first(login_key: app.session[:login_key])).id).destroy
    app.session.clear
    app.flash[:success] = "You are now signed out."
  end

  def self.changealias(params, app)
    @user = (User.first(login_key: app.session[:login_key]))
    if params['newalias'].length <= 15
      @user.update(alias: params['newalias'])
      app.session[:alias] = params['newalias']
    else
      flash[:error] = "Invalid alias. Please try again."
    end
  end

end