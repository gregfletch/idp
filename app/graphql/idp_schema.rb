# frozen_string_literal: true

class IdpSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)
end
