class Seeder
  def self.seed
    self.room
    self.user
    self.room_users
    self.game
    self.language
  end

  def self.room
    Room.create(url: "417kd4cyfs", name: 'Dota 2, no noobs', size: 5, public: TRUE, game: 'Dota 2', language: 'Swedish', creator_id: 1)
    Room.create(url: "ihtwuw85za", name: 'Double AK+ MM', size: 5, public: TRUE, game: 'CS:GO', language: 'English', creator_id: 1)
    Room.create(url: "czrnmssxsn", name: 'T6 Rifts (Paragon >100)', size: 4, public: TRUE, game: 'Diablo 3', language: 'Russian', creator_id: 1)
    Room.create(url: "k4kyubiir3", name: 'ADK games', size: 2, public: TRUE, game: 'Achtung Die Kurwe', language: 'Russian', creator_id: 1)
    Room.create(url: "insj4ie8ul", name: 'Please join :(', size: 4, public: TRUE, game: 'Diablo 2', language: 'Russian', creator_id: 1)
    Room.create(url: "jdwail32ld", name: 'HoN MM (3000+ MMR)', size: 5, public: FALSE, game: 'Heroes of Newerth', language: 'Icelandic', creator_id: 1)
    Room.create(url: "ngui1dk2lo", name: 'No-scoping MW2', size: 8, public: TRUE, game: 'Call of Duty', language: 'English', creator_id: 1)
  end

  def self.user
    User.create(name: 'Stefan', admin: TRUE, login_provider: 'Google', login_key: '8594038655935', avatar: '/img/google_logo.png', alias: 'Stefan')
    User.create(name: 'Kalle', admin: FALSE, login_provider: 'Google', login_key: '890128502182', avatar: '/img/google_logo.png', alias: 'Kalle')
    User.create(name: 'Birgit', admin: FALSE, login_provider: 'Facebook', login_key: '12895082019', avatar: '/img/facebook_logo.png', alias: 'Birgit')
    User.create(name: 'Åsa', admin: FALSE, login_provider: 'Facebook', login_key: '58325230142', avatar: '/img/facebook_logo.png', alias: 'Åsa')
    User.create(name: 'Fredrik', admin: FALSE, login_provider: 'Steam', login_key: '58390285093', avatar: '/img/steam_logo.png', alias: 'Fredrik')
    User.create(name: 'Håkan', admin: FALSE, login_provider: 'Steam', login_key: '214891025801', avatar: '/img/steam_logo.png', alias: 'Håkan')
    User.create(name: 'Albin', admin: FALSE, login_provider: 'Steam', login_key: '59302589032', avatar: '/img/steam_logo.png', alias: 'Albin')

    User.create(name: 'Ludwig', admin: TRUE, login_provider: 'Google', login_key: '117555853306123120083', avatar: '/img/google_logo.png', alias: 'Ludwig')
    User.create(name: 'Alf', admin: TRUE, login_provider: 'Steam', login_key: '76561198033810799', avatar: '/img/steam_logo.png', alias: 'Alf')
  end

  def self.room_users
    RoomUser.create(room_id: 1, user_id: 1, ready_until: "21:45", leader: TRUE)
    RoomUser.create(room_id: 2, user_id: 2, ready_until: "18:20", leader: TRUE)
    RoomUser.create(room_id: 3, user_id: 3, ready_until: "20:00", leader: TRUE)
    RoomUser.create(room_id: 4, user_id: 4, ready_until: "19:10", leader: TRUE)
    RoomUser.create(room_id: 4, user_id: 5, ready_until: "16:50", leader: FALSE)
    RoomUser.create(room_id: 5, user_id: 6, ready_until: "22:30", leader: TRUE)
    RoomUser.create(room_id: 6, user_id: 7, ready_until: "23:40", leader: TRUE)
  end

  def self.game
    Game.create(game: "Arma 3")
    Game.create(game: "CS:1.6")
    Game.create(game: "CS:GO")
    Game.create(game: "CS:Source")
    Game.create(game: "Dayz")
    Game.create(game: "H1Z1")
    Game.create(game: "HoN")

  end
  def self.language
    Language.create(language: "Albanian")
    Language.create(language: "Arabic")
    Language.create(language: "Armenian")
    Language.create(language: "Bosnian")
    Language.create(language: "Bulgarian")
    Language.create(language: "Chinese")
    Language.create(language: "Croation")
    Language.create(language: "Czech")
    Language.create(language: "Danish")
    Language.create(language: "Dutch")
    Language.create(language: "Estonian")
    Language.create(language: "English")
    Language.create(language: "Finnish")
    Language.create(language: "French")
    Language.create(language: "Georgian")
    Language.create(language: "German")
    Language.create(language: "Greek")
    Language.create(language: "Hindi")
    Language.create(language: "Hungarian")
    Language.create(language: "Icelandic")
    Language.create(language: "Indonesian")
    Language.create(language: "Irish")
    Language.create(language: "Italian")
    Language.create(language: "Japanese")
    Language.create(language: "Korean")
    Language.create(language: "Indonesian")
    Language.create(language: "Mandarin")
    Language.create(language: "Persian")
    Language.create(language: "Polish")
    Language.create(language: "Portuguese")
    Language.create(language: "Punjabi")
    Language.create(language: "Russian")
    Language.create(language: "Spanish")
    Language.create(language: "Swedish")
    Language.create(language: "Thai")
    Language.create(language: "Turkish")
    Language.create(language: "Ukrainian")
    Language.create(language: "Vietnamese")

  end
end


