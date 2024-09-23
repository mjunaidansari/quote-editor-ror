class TwoFactorAuthController < ApplicationController
  before_action :authenticate_user!

  # display the qr and form for enabling 2fa
  def show
    current_user.generate_otp_secret if current_user.otp_secret.nil?
  end

  # enable 2fa
  def enable
    if current_user.validate_and_consume_otp!(params[:otp_attempt])
      current_user.update(otp_enabled: true)
      redirect_to root_path, notice: 'Two factor authentication enabled successfully'
    else
      flash[:alert] = 'Invalid OTP code, please try again'
      render :show
    end
  end

  # disable 2fa
  def disable
    if current_user.validate_and_consume_otp!(params[:otp_attempt])
      current_user.update(otp_enabled: false, otp_secret: nil)
      redirect_to root_path, notice: 'Two factor authentication disabled successfully'
    else
      flash[:alert] = 'Invalid OTP code, please try again'
      render :show
    end
  end

end
