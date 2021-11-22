# frozen_string_literal: true

class Types::LoginActivityType < Types::BaseObject
  description 'Represents a login activity, which provides information about an authentication attempt (both successful and unsuccessful).'

  field :city, String, null: true, description: 'The IP-geocoded city of where the authentication attempt occurred.'
  field :context, String, null: true, resolver_method: :resolve_context, description: 'The context used to perform the authentication attempt.'
  field :country, String, null: true, description: 'The IP-geocoded country of where the authentication attempt occurred.'
  field :created_at, GraphQL::Types::ISO8601DateTime, null: false, description: 'The timestamp that this login activity was created at, in ISO-8601 format.'
  field :failure_reason, String, null: true, description: 'The reason for a failed authentication attempt.'
  field :id, ID, null: false, description: 'The unique identifier of the login activity tracking an authentication attempt.'
  field :identity, String, null: true, description: 'The username of the user who performed the authentication attempt.'
  field :ip, String, null: true, description: 'The IP address of the user who performed the authentication attempt.'
  field :latitude, Float, null: true, description: 'The IP-geocoded latitude of where the authentication attempt occurred.'
  field :longitude, Float, null: true, description: 'The IP-geocoded longitude of where the authentication attempt occurred.'
  field :referrer, String, null: true, description: 'The HTTP referrer URL.'
  field :region, String, null: true, description: 'The IP-geocoded region location of where the authentication attempt occurred.'
  field :scope, String, null: true, description: 'The scope used for authenticating the user account.'
  field :strategy, String, null: true, description: 'The strategy used to authenticate the user account.'
  field :success, Boolean, null: true, description: 'A boolean value indicating whether or not the authentication attempt was successful.'
  field :updated_at, GraphQL::Types::ISO8601DateTime, null: false, description: 'The timestamp that this login activity was last updated, in ISO-8601 format.'
  field :user_agent, String, null: true, description: 'The browser user agent that was used to generate a given login activity.'
  field :user_id, ID, null: true, description: 'The unique identified of the user associated with this login activity.'
  field :user_type, String, null: true, description: 'The type of user account associated with this login activity.'
end
