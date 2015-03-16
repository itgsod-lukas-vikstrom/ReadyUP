class Violation
  include DataMapper::Resource

  property :id, Serial
  property :reason, String

  belongs_to :user
end