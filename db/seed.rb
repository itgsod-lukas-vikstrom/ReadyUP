class Seeder
  def self.seed
    self.room
    self.user
    self.room_users
  end

  def self.room
    Room.create(url: rand(36**10).to_s(36), name: 'Dota 2, no noobs', size: 5, public: TRUE, game: 'Dota 2', language: 'Swedish')
    Room.create(url: rand(36**10).to_s(36), name: 'Double AK+ MM', size: 5, public: TRUE, game: 'CS:GO', language: 'English')
    Room.create(url: rand(36**10).to_s(36), name: 'T6 Rifts (Paragon >100)', size: 4, public: TRUE, game: 'Diablo 3', language: 'Russian')
    Room.create(url: rand(36**10).to_s(36), name: 'ADK games', size: 2, public: TRUE, game: 'Achtung Die Kurwe', language: 'Russian')
    Room.create(url: rand(36**10).to_s(36), name: 'Please join :(', size: 4, public: TRUE, game: 'Diablo 2', language: 'Russian')
    Room.create(url: rand(36**10).to_s(36), name: 'HoN MM (3000+ MMR)', size: 5, public: FALSE, game: 'Heroes of Newerth', language: 'Icelandic')
    Room.create(url: rand(36**10).to_s(36), name: 'No-scoping MW2', size: 8, public: FALSE, game: 'Call of Duty', language: 'English')
  end

  def self.user
    User.create(name: 'Stefan', admin: TRUE, login_provider: 'Google', login_key: '8594038655935', avatar: '/img/google_logo.png')
    User.create(name: 'Kalle', admin: TRUE, login_provider: 'Google', login_key: '890128502182', avatar: '/img/google_logo.png')
    User.create(name: 'Birgit', admin: TRUE, login_provider: 'Facebook', login_key: '12895082019', avatar: '/img/facebook_logo.png')
    User.create(name: 'Åsa', admin: TRUE, login_provider: 'Facebook', login_key: '58325230142', avatar: '/img/facebook_logo.png')
    User.create(name: 'Fredrik', admin: TRUE, login_provider: 'Steam', login_key: '58390285093', avatar: '/img/steam_logo.png')
    User.create(name: 'Håkan', admin: TRUE, login_provider: 'Steam', login_key: '214891025801', avatar: '/img/steam_logo.png')
    User.create(name: 'Albin', admin: TRUE, login_provider: 'Steam', login_key: '59302589032', avatar: '/img/steam_logo.png')
  end

  def self.room_users
    RoomUser.create(room_id: 1, user_id: 1, ready_until: "12:45", leader: TRUE)
    RoomUser.create(room_id: 2, user_id: 2, ready_until: "18:20", leader: TRUE)
    RoomUser.create(room_id: 3, user_id: 3, ready_until: "14:00", leader: TRUE)
    RoomUser.create(room_id: 4, user_id: 4, ready_until: "12:10", leader: TRUE)
    RoomUser.create(room_id: 4, user_id: 5, ready_until: "16:50", leader: FALSE)
    RoomUser.create(room_id: 5, user_id: 6, ready_until: "08:30", leader: TRUE)
    RoomUser.create(room_id: 6, user_id: 7, ready_until: "10:40", leader: TRUE)
  end
end


