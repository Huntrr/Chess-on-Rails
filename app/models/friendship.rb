class Friendship < ActiveRecord::Base
  validates_uniqueness_of :user_id, scope: :friend_id

  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'
end
