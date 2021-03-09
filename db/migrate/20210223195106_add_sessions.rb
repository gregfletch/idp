# frozen_string_literal: true

class AddSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :sessions, id: :uuid do |t|
      t.datetime :consumed_at
      t.references :user, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
