class Room
  include DataMapper::Resource

  property :id, Serial
  property :url, String, :required => true
  property :name, String, :required => true
  property :size, Integer, :required => true
  property :public, Boolean, :required => true
  property :game, String
  property :language, String
  property :creator_id, String, :required => true

  has n, :user, :through => Resource

  validates_length_of :url, :equals => 10
  validates_uniqueness_of :url
  validates_length_of :name, :within => 1..24
  validates_numericality_of :size
  validates_with_method :size, :method => :valid_range?
  validates_numericality_of :creator_id

  def valid_range?
    if @size.between?(1, 99)
      return true
    else
      return [false, "Invalid group size."]
    end
  end

  def users
    users = []
    for roomuser in RoomUser.all(room: self)
      users << User.first(id: roomuser.user_id)
    end
    return users
  end

  def self.build(params, app)

    newroom = Room.create(url: rand(36**10).to_s(36),
                          name: params['groupname'],#skapar ett slumpmässigt token som URL
                          size: params['size'],
                          public: params['publicity'],
                          game: params['game'],
                          language: params['language'],
                          creator_id: app.session[:login_key])
    if newroom.save
      app.flash[:success] = 'Group successfully created'
      redirect_url = "room/#{newroom.url}"
    else
      newroom.errors.each do |e|
        puts e
      end
      app.flash[:error] = "Invalid group parameters. Please try again."
    end
    return redirect_url
  end
end