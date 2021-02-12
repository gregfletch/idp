# frozen_string_literal: true

class Types::BaseObject < GraphQL::Schema::Object
  field_class Types::BaseField

  # Use this class for defining connections
  connection_type_class Types::TotalCountConnection
end
