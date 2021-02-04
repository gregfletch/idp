# frozen_string_literal: true

Geocoder.configure(
  ip_lookup: :geoip2,
  geoip2: {
    file: Rails.root.join('lib', 'assets', 'maxmind', 'GeoLite2-City.mmdb')
  }
)
