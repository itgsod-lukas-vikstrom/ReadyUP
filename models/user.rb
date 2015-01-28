class User
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true
  property :admin, Boolean, :required => true
  property :login_provider, String, :required => true
  property :login_key, String, :required => true

  belongs_to :room

end