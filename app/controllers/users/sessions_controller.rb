class Users::SessionsController < Devise::SessionsController
  # Override the create method to enforce OTP check
  def create
    user = User.find_by(email: params[:user][:email])

    # Authenticate user with password first
    if user && user.valid_password?(params[:user][:password])
      # Check if OTP is enabled
      if user.otp_enabled?
        session[:user_id] = user.id
        redirect_to verify_otp_path and return
      else
        # If OTP is not enabled, sign them in directly
        sign_in user
        redirect_to root_path, notice: 'Logged in successfully'
      end
    else
      # Handle invalid login credentials
      flash[:alert] = 'Invalid email or password'
      render :new
    end
  end

  # OTP verification page
  def verify_otp
    if session[:user_id].nil?
      redirect_to new_user_session_path
    end
  end

  # Check OTP and sign in the user if valid
  def check_otp
    user = User.find(session[:user_id])
    if user.validate_and_consume_otp!(params[:otp_attempt])
      session[:otp_verified] = true
      sign_in(user)
      session.delete(:user_id) # Clean up session
      redirect_to root_path, notice: 'Logged in successfully'
    else
      flash[:alert] = 'Invalid OTP code, please try again.'
      render :verify_otp
    end
  end
end
