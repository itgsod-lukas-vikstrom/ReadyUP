class Violation
  include DataMapper::Resource

  property :id, Serial
  property :reason, String

  belongs_to :user

  def self.send_violation(params)
    user = User.first(id: params['userid'])
    user.update(:banned => TRUE)
    Violation.create(reason: params['reason'], user_id: params['userid'])
    Report.first(id: params['id']).destroy
    RoomUser.all(user_id: params['userid']).destroy
  end
end
