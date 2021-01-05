# frozen_string_literal: true

class AddMissingColumnToDoorkeeperApplications < ActiveRecord::Migration[6.1]
  def change
    # rubocop:disable Rails/NotNullColumn
    add_column :oauth_applications, :uid, :string, null: false
    # rubocop:enable Rails/NotNullColumn
    add_index :oauth_applications, :uid, unique: true
  end
end
