require 'twilio-ruby'

module Twilio
    class SmsServise
        def initialize(to:, pin:)
                @to = to
                @pin = pin
            end
        def send_otp
                account_sid = 'ACb1286d25f91ec950d7f7364e7f29b493'
                auth_token = 'dd1eda2d034ecd50d89e0d993b32853a'
                from = '+917019824855'
                @client = Twilio::REST::Client.new(account_sid, auth_token)
                verification = @client.verify
                                .v2
                                .services('VAc24d74e771a3d4c4beaa9271d968dc92')
                                .verifications
                                .create(to: @to, channel: 'sms')
                end
         def verify_otp
                account_sid = 'ACb1286d25f91ec950d7f7364e7f29b493'
                auth_token = 'dd1eda2d034ecd50d89e0d993b32853a'
                @client = Twilio::REST::Client.new(account_sid, auth_token)
                verification_check = @client.verify
                                    .v2
                                    .services('VAc24d74e771a3d4c4beaa9271d968dc92')
                                    .verification_checks
                                    .create(to: @to, code: @pin)
                                    return {status: verification_check.status}
        end
    end
end