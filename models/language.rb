class Language
  include DataMapper::Resource
  property :id, Serial
  property :language, String
end