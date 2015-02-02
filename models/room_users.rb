class Room_Users
  include DataMapper::Resource
  property :id, Serial
  property :ready_until, DateTime, :required => true
  property :leader, Boolean, :required => true

end
