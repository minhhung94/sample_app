class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  before_save :downcase_email
  before_create :create_activation_digest

  VALID_EMAIL_REGEX = Settings.validations.user.email.REGEX

  validates :email, presence: true,
                  length: {maximum: Settings.validations.user.email.max_length},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: true
  validates :password, presence: true,
              length: {minimum: Settings.validations.user.password.min_length},
              allow_nil: true
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

  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false unless digest

    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update remember_digest: nil
  end

  # Activates an account.
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private
  # Converts email to all lower-case.
  def downcase_email
    email.downcase!
  end

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
