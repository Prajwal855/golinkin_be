require 'twilio-ruby'

module Twilio
    class SmsServise
        def initialize(to:, pin:)
                @to = to
                @pin = pin
            end
        def send_otp
                from = '+917019824855'
                @client = Twilio::REST::Client.new(account_sid, auth_token)
                verification = @client.verify
                                .v2
                                
                                .verifications
                                .create(to: @to, channel: 'sms')
                end
         def verify_otp
                @client = Twilio::REST::Client.new(account_sid, auth_token)
                verification_check = @client.verify
                                    .v2
                                    .verification_checks
                                    .create(to: @to, code: @pin)
                                    return {status: verification_check.status}
        end
    end
end