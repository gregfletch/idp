# frozen_string_literal: true

class Types::BaseObject < GraphQL::Schema::Object
  field_class Types::BaseField
end
