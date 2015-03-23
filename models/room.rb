class Room
  include DataMapper::Resource

  property :id, Serial
  property :url, String, :required => true
  property :name, String, :required => true
  property :size, Integer, :required => true
  property :public, Boolean, :required => true
  property :game, String
  property :language, String
  property :creator_id, String

  has n, :user, :through => Resource

  def users
    users = []
    for roomuser in RoomUser.all(room: self)
      users << User.first(id: roomuser.user_id)
    end
    return users
  end
end