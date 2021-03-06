require "dry/transaction"
class CreateUser
  include Dry::Transaction
  step :validate
  tee :create
  tee :sendWelcomeEmail

  private

  def validate(input)
    @user = input[:user]
    if @user.valid?
      Success(input)
    else
      Failure(input.merge(error: @user.errors.full_messages.uniq.join('. ')))
    end
  end

  def create(input)
    @user.save
  end
  def sendWelcomeEmail(input)
    @user = User.last
    mailer = UserMailer.with(user: @user).welcome_email.deliver_now
  end
end
