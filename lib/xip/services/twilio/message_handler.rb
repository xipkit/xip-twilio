# frozen_string_literal: true

module Xip
  module Services
    module Twilio
      class MessageHandler < Xip::Services::BaseMessageHandler
        attr_reader :service_message, :params, :headers

        def initialize(params:, headers:)
          @params = params
          @headers = headers
        end

        def coordinate
          Xip::Services::HandleMessageJob.perform_async(
            'twilio',
            params,
            headers
          )

          # Relay our acceptance
          [204, 'No Content']
        end

        def process
          @service_message = ServiceMessage.new(service: 'twilio')
          service_message.sender_id = params['From']
          service_message.target_id = params['To']
          service_message.message = params['Body']

          # Check for media attachments
          attachment_count = params['NumMedia'].to_i

          attachment_count.times do |i|
            service_message.attachments << {
              type: params["MediaContentType#{i}"],
              url: params["MediaUrl#{i}"]
            }
          end

          service_message
        end

      end

    end
  end
end
