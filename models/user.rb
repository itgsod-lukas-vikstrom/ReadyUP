class User
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :time, Integer
  2
  has n, :room, :through => Resource
end