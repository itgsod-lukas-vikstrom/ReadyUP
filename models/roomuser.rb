class RoomUser
  include DataMapper::Resource

  property :id, Serial
  property :ready_until, DateTime, :required => true
  property :leader, Boolean, :required => true

  belongs_to :room
  belongs_to :user

  def check_time
    if self.ready_until <= DateTime.now + 0.041666
      self.destroy
    end
  end
end
