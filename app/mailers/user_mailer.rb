class UserMailer < ApplicationMailer

  default from: 'no-reply@audiohealthpal.com'

  def user_message
    @message_template = params[:message_template]
    mail(to: params[:user].email, subject: @message_template.subject)
  end

  def recording_ready
    recording = params[:recording]

    recipient = 'will.haslett@dartmouth.edu'
    htmlbody = 'Foo!'
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
              data: htmlbody,
            },
            text: {
              charset: 'UTF-8',
              data: 'foo',
            },
          },
          subject: {
            charset: 'UTF-8',
            data: 'Yes!',
          },
        },
        source: 'no-reply@audiohealthpal.com',
      })
      puts "Email sent!"
    rescue Aws::SES::Errors::ServiceError => error
      puts "Email not sent. Error message: #{error}"
    end
  end

end
