# frozen_string_literal: true

require 'xip/services/twilio/client'

module Xip
  module Services
    module Twilio

      class Setup

        class << self
          def trigger
            Xip::Logger.l(
              topic: "twilio",
              message: "There is no setup needed!"
            )
          end
        end

      end

    end
  end
end
