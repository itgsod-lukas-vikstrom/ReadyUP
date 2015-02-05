class Seeder
  def self.seed
    self.room
    self.user
    self.room_users
  end

  def self.room
    Room.create(url: 'ddhwbz', name: 'dogecoin', size: 5, public: 'public', game: 'Dota2', language: 'Swedish')
  end
  def self.user
    User.create(name: 'GaemMastar', admin: true, login_provider: 'Steam', login_key: '%hjh34hhg2_jkh5j2' )
  end
  def self.room_users
    RoomUser.create(room_id: 1, user_id: 1, ready_until: "12:45", leader: false)
  end
end


