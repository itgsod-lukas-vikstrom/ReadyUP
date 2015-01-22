class Room
  include DataMapper::Resource

  property :id, Serial
  property :url, String
  property :name, String
  property :size, Integer
  property :publicity, String
  property :game, String
  property :language, String


  has n, :user, :through => Resource
end