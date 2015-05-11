class RoomUser
  include DataMapper::Resource

  property :id, Serial
  property :ready_until, DateTime, :required => true
  property :leader, Boolean, :required => true

  belongs_to :room
  belongs_to :user

  def check_time
    if self.ready_until <= DateTime.now + 1/24.to_f
      self.destroy
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
    room = Room.first(url: url)
    if room.user.length < room.size
      time = params['hour'] + ':' + params['minute']
      RoomUser.create(room_id: room.id, user_id: (User.first(login_key: app.session[:login_key])).id, leader: TRUE, ready_until: time)
      redirect_url = '/room/' + url
    else
      app.flash[:error] = "Room is full."
      redirect_url = '/'
    end
    return redirect_url
  end

  def timezone_offset
    if self.ready_until < DateTime.now + 1/24.to_f
      self.update(ready_until: (self.ready_until) + 1)
    end
  end
end