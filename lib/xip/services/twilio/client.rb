# frozen_string_literal: true

require 'twilio-ruby'

require 'xip/services/twilio/message_handler'
require 'xip/services/twilio/reply_handler'
require 'xip/services/twilio/setup'

module Xip
  module Services
    module Twilio
      class Client < Xip::Services::BaseClient

        attr_reader :twilio_client, :reply

        def initialize(reply:)
          @reply = reply
          account_sid = Xip.config.twilio.account_sid
          api_key = Xip.config.twilio.api_key
          auth_token = Xip.config.twilio.auth_token

          if api_key.present?
            @twilio_client = ::Twilio::REST::Client.new(
              api_key, auth_token, account_sid
            )
          else
            @twilio_client = ::Twilio::REST::Client.new(account_sid, auth_token)
          end
        end

        def transmit
          # Don't transmit anything for delays
          return true if reply.blank?

          begin
            response = twilio_client.messages.create(reply)
          rescue ::Twilio::REST::RestError => e
            case e.message
            when /21610/ # Attempt to send to unsubscribed recipient
              raise Xip::Errors::UserOptOut
            when /21612/ # 'To' phone number is not currently reachable via SMS
              raise Xip::Errors::UserOptOut
            when /21614/ # 'To' number is not a valid mobile number
              raise Xip::Errors::UserOptOut
            when /30004/ # Message blocked
              raise Xip::Errors::UserOptOut
            when /21211/ # Invalid 'To' Phone Number
              raise Xip::Errors::InvalidSessionID
            when /30003/ # Unreachable destination handset
              raise Xip::Errors::InvalidSessionID
            when /30005/ # Unknown destination handset
              raise Xip::Errors::InvalidSessionID
            else
              raise
            end
          end

          Xip::Logger.l(
            topic: "twilio",
            message: "Transmitting. Response: #{response.status}: #{response.error_message}"
          )
        end

      end
    end
  end
end
