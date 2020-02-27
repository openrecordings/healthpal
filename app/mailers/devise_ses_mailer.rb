class DeviseSesMailer < ApplicationMailer

    def confirmation_instructions(record, token, opts={})
      @token = token
      devise_mail(record, :confirmation_instructions, opts)
    end

    def reset_password_instructions(record, token, opts={})
      recipient = 'will.haslett@dartmouth.edu'
      ses = Aws::SES::Client.new(region: 'us-east-1')
      begin
        resp = ses.send_email({
          destination: {
            to_addresses: [
              recipient,
            ],
          },
          message: {
            body: {
              html: {
                charset: 'UTF-8',
                data: token,
              },
              text: {
                charset: 'UTF-8',
                data: token,
              },
            },
            subject: {
              charset: 'UTF-8',
              data: 'new email',
            },
          },
          source: 'no-reply@audiohealthpal.com',
        })
        puts "Email sent!"
      rescue Aws::SES::Errors::ServiceError => error
        puts "Email not sent. Error message: #{error}"
      end
    end

    def unlock_instructions(record, token, opts={})
      @token = token
      devise_mail(record, :unlock_instructions, opts)
    end

    def email_changed(record, opts={})
    end

    def password_change(record, opts={})
      devise_mail(record, :password_change, opts)
    end

end
