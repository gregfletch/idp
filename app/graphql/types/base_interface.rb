# frozen_string_literal: true

class Types::BaseInterface
  include GraphQL::Schema::Interface

  field_class Types::BaseField
end
