class User < ApplicationRecord

  VALID_EMAIL_REGEX = Settings.validations.user.email.REGEX

  attr_accessor :remember_token

  before_save :downcase_email

  validates :email, presence: true,
                  length: {maximum: Settings.validations.user.email.max_length},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: true
  validates :password, presence: true,
              length: {minimum: Settings.validations.user.password.min_length}
  validates :name, presence: true,
                   length: {maximum: Settings.validations.user.name.max_length}

  has_secure_password

  def self.digest string
    if ActiveModel::SecurePassword.min_cost
      BCrypt::Password.create string, cost: BCrypt::Engine::MIN_COST
    else
      BCrypt::Password.create string, cost: BCrypt::Engine.cost
    end
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false unless remember_digest

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update remember_digest: nil
  end
end
