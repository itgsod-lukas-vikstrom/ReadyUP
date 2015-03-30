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

  validates_length_of :name, :within => 4..14
  validates_with_method :login_provider, :method => :valid_login_provider?
  validates_numericality_of :login_key
  validates_with_method :avatar, :method => :valid_avatar?
  validates_length_of :alias, :within => 4..14

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


  def self.build(env, login_provider, app)
    env ? app.session[:member] = true : halt(401,'Not Authorized')
    if User.first(login_key: env['uid']).nil? && (login_provider == 'steam' || login_provider == 'google')
      User.create(name: env['info']['nickname'],
                  admin: FALSE,
                  login_provider: 'Steam',
                  login_key: env['uid'],
                  avatar: env['extra']['raw_info']['avatar'],
                  alias: env['info']['nickname']) if login_provider == 'steam'
      User.create(name: env['info']['first_name'],
                  admin: FALSE,
                  login_provider: 'Google',
                  login_key: env['uid'],
                  avatar: '/img/google_logo.png',
                  alias: env['info']['first_name']) if login_provider == 'google'
    elsif User.first(login_key: env['extra']['raw_info']['id']).nil? && login_provider == 'facebook'
      User.create(name: env['info']['first_name'],
                  admin: FALSE,
                  login_provider: 'Facebook',
                  login_key: env['extra']['raw_info']['id'],
                  avatar: '/img/facebook_logo.png',
                  alias: env['info']['first_name'])
    end
    user = User.first(login_key: env['uid'])
    if user.banned?
      app.session[:member] = nil
      app.flash[:error] = "You are banned. Please contact administrators."
      redirect '/'
    end
    if login_provider == 'steam'
      app.session[:name] = env['info']['nickname']
      app.session[:login_key] = env['uid']
      app.session[:avatar] = env['extra']['raw_info']['avatar']
      redirect_url = '/login/steam'
    elsif login_provider == 'google'
      app.session[:name] = env['info']['first_name']
      app.session[:login_key] = env['uid']
      app.session[:avatar] = '/img/google_logo.png'
      redirect_url = '/login/google'
    elsif login_provider == 'facebook'
      app.session[:name] = env['info']['first_name']
      app.session[:login_key] = env['extra']['raw_info']['id']
      app.session[:avatar] = '/img/facebook_logo.png'
      redirect_url = '/login/facebook'
    end
    app.session[:alias] = user.alias
    app.session[:member] = true
    app.session[:admin] = true if user.admin?
    app.flash[:success] = "You are now logged in."
    return redirect_url
  end

  def in_room?(room)
    RoomUser.first(room_id: room.id, user_id: self.id)
  end
  def self.logout(app)
    RoomUser.all(user_id: (User.first(login_key: app.session[:login_key])).id).destroy
    app.session.clear
    app.flash[:success] = "You are now logged out."
  end

  def self.changealias(params,app)
    @user = (User.first(login_key: app.session[:login_key]))
    if params['newalias'].length <= 15
      @user.update(alias: params['newalias'])
      app.session[:alias] = params['newalias']
    else
      flash[:error] = "Invalid alias. Please try again."
    end
  end

  def banned?
    if self.banned
      return true
    else
      return false
    end
  end
end