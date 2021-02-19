# frozen_string_literal: true

class LoginActivity < ApplicationRecord
  belongs_to :user, polymorphic: true, optional: true
  scope :for_user, ->(user) { where(user_id: user) }
end
