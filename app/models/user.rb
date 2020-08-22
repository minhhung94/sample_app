class User < ApplicationRecord

  VALID_EMAIL_REGEX = Settings.validations.user.email.REGEX

  validates :email, presence: true,
                  length: {maximum: Settings.validations.user.email.max_length},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: true
  validates :password, presence: true,
              length: {minimum: Settings.validations.user.password.min_length}
  validates :name, presence: true,
                   length: {maximum: Settings.validations.user.name.max_length}

  has_secure_password

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ?
      BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
  end

  before_save :downcase_email

  private
  def downcase_email
    email.downcase!
  end
end
