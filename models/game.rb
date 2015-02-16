class Game
  include DataMapper::Resource
  property :id, Serial
  property :game, String
end