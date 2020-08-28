class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.validations.user.email.REGEX

  PERMITTED_ATTR = %i(email password name password_confirmation).freeze

  validates :email, presence: true,
                  length: {maximum: Settings.validations.user.email.max_length},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: true
  validates :password, presence: true,
              length: {minimum: Settings.validations.user.password.min_length}
  validates :name, presence: true,
                   length: {maximum: Settings.validations.user.name.max_length}

  has_secure_password

  before_save :downcase_email

  private

  def downcase_email
    email.downcase!
  end
end
