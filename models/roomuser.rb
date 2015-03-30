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
  def self.checkout(params,app)
    @room = Room.first(id: params['id'])
    RoomUser.first(user: User.first(login_key: app.session[:login_key]), room: @room).destroy
  end
  def self.remove_room(id,app)
    @roomusers = RoomUser.all(room_id: id)
    @roomusers.each do |user|
      user.destroy
    end
    Room.first(id: id).destroy
  end


  def timezone_offset
    if self.ready_until < DateTime.now + 1/24.to_f
      self.update(ready_until: (self.ready_until) + 1)
    end
  end
end