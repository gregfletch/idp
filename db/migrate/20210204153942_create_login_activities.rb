# frozen_string_literal: true

class CreateLoginActivities < ActiveRecord::Migration[6.1]
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def change
    create_table :login_activities, id: :uuid do |t|
      t.string :scope
      t.string :strategy
      t.string :identity
      t.boolean :success
      t.string :failure_reason
      t.references :user, polymorphic: true
      t.string :context
      t.string :ip
      t.text :user_agent
      t.text :referrer
      t.string :city
      t.string :region
      t.string :country
      t.float :latitude
      t.float :longitude

      t.timestamps
    end

    add_index :login_activities, :identity
    add_index :login_activities, :ip
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
