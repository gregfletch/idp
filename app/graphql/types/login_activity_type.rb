# frozen_string_literal: true

class Types::LoginActivityType < Types::BaseObject
  field :id, ID, null: false
  field :scope, String, null: true
  field :strategy, String, null: true
  field :identity, String, null: true
  field :success, Boolean, null: true
  field :failure_reason, String, null: true
  field :user_type, String, null: true
  field :user_id, ID, null: true
  field :context, String, null: true, resolver_method: :resolve_context
  field :ip, String, null: true
  field :user_agent, String, null: true
  field :referrer, String, null: true
  field :city, String, null: true
  field :region, String, null: true
  field :country, String, null: true
  field :latitude, Float, null: true
  field :longitude, Float, null: true
  field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
end
