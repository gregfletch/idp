# frozen_string_literal: true

class User < ApplicationRecord
  devise :two_factor_authenticatable,
         otp_secret_encryption_key: Rails.application.credentials.devise_two_factor_encryption_key

  devise :two_factor_backupable, otp_backup_code_length: 16, otp_number_of_backup_codes: 10

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :registerable, :recoverable, :validatable, :trackable, :confirmable, :lockable, :timeoutable, :two_factor_backupable

  validates :username, presence: true, length: 1..255, uniqueness: true
  validates :first_name, presence: true, length: 1..128, name: true
  validates :last_name, presence: true, length: 1..128, name: true
  validates :email, presence: true, length: 1..255, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :encrypted_password, presence: true
  validates :sign_in_count, presence: true, numericality: true
  validates :failed_attempts, presence: true, numericality: true
  validates :current_sign_in_ip, format: { with: Regexp.union(Resolv::IPv4::Regex, Resolv::IPv6::Regex) },
                                 allow_blank: true
  validates :last_sign_in_ip, format: { with: Regexp.union(Resolv::IPv4::Regex, Resolv::IPv6::Regex) },
                              allow_blank: true
  validates :password, password_composition: true

  before_validation :set_username_if_missing

  has_many :access_grants, class_name: 'Doorkeeper::AccessGrant', foreign_key: :resource_owner_id, dependent: :delete_all, inverse_of: false
  has_many :access_tokens, class_name: 'Doorkeeper::AccessToken', foreign_key: :resource_owner_id, dependent: :delete_all, inverse_of: false
  has_many :login_activities, as: :user, dependent: :destroy
  has_many :sessions, dependent: :destroy

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    return nil if user.blank?

    user.active_for_authentication? && user.valid_password?(password) ? user : nil
  end

  private

  def set_username_if_missing
    self.username = email if username.blank?
  end
end
