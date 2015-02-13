class RoomUser
  include DataMapper::Resource

  property :id, Serial
  property :ready_until, String, :required => true
  property :leader, Boolean, :required => true

  belongs_to :room
  belongs_to :user
end
