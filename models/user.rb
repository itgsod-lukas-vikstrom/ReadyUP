require 'dm-validations'

class User
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true
  property :admin, Boolean, :required => true
  property :login_provider, String, :required => true
  property :login_key, Text, :required => true
  property :avatar, Text
  property :alias, Text
  property :banned, Boolean

  has n, :room, :through => :roomusers
  has 1, :report

  validates_length_of :name, :within => 4..14
  validates_with_method :login_provider, :method => :valid_login_provider?
  validates_numericality_of :login_key
  validates_with_method :avatar, :method => :valid_avatar?
  validates_length_of :alias, :within => 4..14

  def valid_login_provider?
    if @login_provider == "Steam" || @login_provider == "Google" || @login_provider == "Facebook"
      return true
    else
      return [false, "Incorrect login provider."]
    end
  end

  def valid_avatar?
    if @avatar.end_with?(".jpg") || @avatar.end_with?(".png")
      return true
    else
      return [false, "Incorrect avatar image."]
    end
  end

  def in_room?(room)
    RoomUser.first(room_id: room.id, user_id: self.id)
  end

  def banned?
    if self.banned
      return true
    else
      return false
    end
  end
end