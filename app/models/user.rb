class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.validations.user.email.REGEX

  before_save{email.downcase!}
  validates :name, presence: true,
    length: {maximum: Settings.validations.user.name.max_length}

  validates :email, presence: true,
    length: {maximum: Settings.validations.user.email.max_length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: true

  validates :password, presence: true,
    length: {minimum: Settings.validations.user.password.min_length}

  has_secure_password
end
