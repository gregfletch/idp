# frozen_string_literal: true

class AddDeviseTwoFactorToUsers < ActiveRecord::Migration[6.1]
  def change
    change_table :users, bulk: true do |t|
      t.string :encrypted_otp_secret
      t.string :encrypted_otp_secret_iv
      t.string :encrypted_otp_secret_salt
      t.integer :consumed_timestep
      t.boolean :otp_required_for_login
      t.string :otp_backup_codes, array: true
    end
  end
end
