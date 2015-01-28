class Violation
  include DataMapper::Resource

  property :id, Serial
  property :end_date, DateTime

  belongs_to :user
end