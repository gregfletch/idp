# frozen_string_literal: true

class Types::TotalCountConnection < GraphQL::Types::Relay::BaseConnection
  field :total_count, Integer, null: false

  def total_count
    object.items.size
  end
end
