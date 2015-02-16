class Report
  include DataMapper::Resource

  property :id, Serial
  property :type, String
  property :comment, String
  belongs_to :user
end