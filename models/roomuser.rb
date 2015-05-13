class RoomUser
  include DataMapper::Resource

  property :id, Serial
  property :ready_until, DateTime, :required => true
  property :leader, Boolean, :required => true

  belongs_to :room
  belongs_to :user

  def check_time
    if self.ready_until.strftime("%d:%H:%M") <= DateTime.now.strftime("%d:%H:%M")
      self.destroy
    end
  end

  def self.ready_until(user_id, room_id)
    roomuser = RoomUser.first(user_id: user_id, room_id: room_id)
    if roomuser != nil
      return roomuser.ready_until
    end
  end

  def self.checkout(url, app)
    @room = Room.first(url: url)
    roomuser = RoomUser.first(user: User.first(login_key: app.session[:login_key]), room: @room)
    roomuser.destroy if roomuser != nil
    redirect_url = '/room/' + url
    return redirect_url
  end

  def self.remove_room(id,app)
    @roomusers = RoomUser.all(room_id: id)
    @roomusers.each do |user|
      user.destroy
    end
    Room.first(id: id).destroy
  end

  def self.checkin(params, url, app)
    puts "VAOKDLAWINDAOWNDOUAWDNOIAWHJDIAWJDOIAWHDA"
    puts "_____________"
    room = Room.first(url: url)
    if room.user.length < room.size
      if params['hour'].to_i <= Time.now.hour.to_i && params['minute'].to_i <= Time.now.min.to_i
        timedate= DateTime.new(Time.now.year,
                               Time.now.month,
                               (Time.now.day+1),
                               params['hour'].to_i,
                               params['minute'].to_i)
      else
        timedate= DateTime.new(Time.now.year,
                               Time.now.month,
                               (Time.now.day+0),
                               params['hour'].to_i,
                               params['minute'].to_i)
      end
      RoomUser.create(room_id: room.id,
                      user_id: (User.first(login_key: app.session[:login_key])).id,
                      leader: FALSE,
                      ready_until: timedate)
      redirect_url = '/room/' + url
    else
      app.flash[:error] = "Room is full."
      redirect_url = '/'
    end
    return redirect_url
  end


end