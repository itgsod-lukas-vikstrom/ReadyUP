class Seeder
  def self.seed
    self.room
    self.user
    self.room_users
  end

  def self.room
    Room.create(name: 'dogecoin', size: 5, publicity: public )
  end
  def self.user
    User.create(name: 'hunden', time: 2)
  end
  def self.room_users
    RoomUser.create(room_id: 1, user_id: 1)
  end
end