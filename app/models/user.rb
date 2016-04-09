class User < ActiveRecord::Base
  include BCrypt

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :name, length: { minimum: 2 }
  validate :name_starts_with_letter

  validates :bio, presence: true
  validates :bio, length: { minimum: 4 }

  validates :password_hash, presence: true

  has_many :friendships, -> { where accepted: true }, dependent: :destroy
  has_many :pending_friendships, -> { where accepted: false }, class_name: 'Friendship', dependent: :destroy
  has_many :friend_requests_relationships, -> { where accepted: false }, class_name: 'Friendship', foreign_key: 'friend_id', dependent: :destroy

  has_many :friends, source: :friend, through: :friendships
  has_many :pending_friends, source: :friend, through: :pending_friendships
  has_many :friend_requests, through: :friend_requests_relationships, source: :user
  
  has_many :games

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def letter?(pattern)
    !(pattern =~ /[A-Z]/i).nil?
  end

  def name_starts_with_letter
    errors.add(:name, 'name does not start with letter') unless name.nil? || name.empty? || letter?(name.chars.first)
  end

  def send_friend_request(id)
    friend = User.find(id)
    unless friend.nil?
      if self.friend_requests.exists? friend
        accept_friend_request(friend)
      else
        self.pending_friendships.create({ friend: friend, accepted: false })
        friend.friend_requests_relationships.create({ user: self, accepted: false })
      end
    end

    self.save
    friend.save
  end

  def force_add_friend(friend)
    self.friendships.create({ friend: friend, accepted: true})
    self.save
  end

  def accept_friend_request(friend)
    self.friend_requests_relationships.find_by(user: friend).delete
    self.friendships.create({ friend: friend, accepted: true })
    friend.force_add_friend self
    self.save
  end

  def delete_friend(id)
    friend = User.find(id)
    self.friendships.find_by(friend: friend).delete
    self.save
  end
end
