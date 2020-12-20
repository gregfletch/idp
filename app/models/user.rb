# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable, :confirmable,
         :lockable, :timeoutable

  validates :username, presence: true, length: 1..128, uniqueness: true
  validates :first_name, presence: true, length: 1..128
  validates :last_name, presence: true, length: 1..128
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

  private

  def set_username_if_missing
    self.username = email if username.blank?
  end
end
