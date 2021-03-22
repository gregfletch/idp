# frozen_string_literal: true

# Define an application-wide HTTP permissions policy. For further
# information see https://developers.google.com/web/updates/2018/06/feature-policy
#
Rails.application.config.permissions_policy do |pp|
  pp.accelerometer        :none
  pp.ambient_light_sensor :none
  pp.autoplay             :none
  pp.camera               :none
  pp.encrypted_media      :none
  pp.fullscreen           :none
  pp.geolocation          :none
  pp.gyroscope            :none
  pp.magnetometer         :none
  pp.microphone           :none
  pp.midi                 :none
  pp.payment              :none
  pp.picture_in_picture   :none
  pp.speaker              :none
  pp.usb                  :none
  pp.vibrate              :none
  pp.vr                   :none
end
