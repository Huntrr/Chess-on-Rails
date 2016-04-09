class User < ActiveRecord::Base
  include BCrypt

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :name, length: { minimum: 2 }
  validate :name_starts_with_letter

  validates :bio, presence: true
  validates :bio, length: { minimum: 4 }

  validates :password_hash, presence: true

  has_many :friendships, dependent: :destroy
  has_many :friends, source: :friend, through: :friendships
  
  has_many :games, dependent: :destroy

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
end
