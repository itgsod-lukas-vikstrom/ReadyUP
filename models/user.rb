class User
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true
  property :admin, Boolean#, :required => true
  property :login_provider, String#, :required => true
  property :login_key, Text#, :required => true
  property :avatar, Text

  has n, :room, :through => :roomusers
  has 1, :report
  def authenticate(login_key)
    if self.login_key == login_key
      true
    else
      false
    end
  end

  def banned?
    Violation.first(user_id: self.id)

  end
end