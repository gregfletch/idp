# frozen_string_literal: true

class Types::TotalCountConnection < GraphQL::Types::Relay::BaseConnection
  description 'A connection for returning the total number of items in a collection.'

  field :total_count, Integer, null: false, description: 'The total number of items.'

  def total_count
    object.items.size
  end
end
