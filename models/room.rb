class Room
  include DataMapper::Resource

  property :id, Serial
  property :url, String, :required => true
  property :name, String, :required => true
  property :size, Integer, :required => true
  property :public, Boolean, :required => true
  property :game, String
  property :language, String

  has n, :user, :through => Resource
end