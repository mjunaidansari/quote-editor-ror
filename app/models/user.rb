class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :validatable

  belongs_to :company

  # generate and save new otp secret if doesnt already exist
  def generate_otp_secret
    self.otp_secret ||= ROTP::Base32.random_base32
    save!
  end

  # generates the qrcode url to be scanned by authenticator app
  def otp_provisioning_uri
    issuer = 'MyApp'
    label = "#{issuer}:#{self.email}"
    ROTP::TOTP.new(self.otp_secret, isseur: issuer).provisioning_uri(label)
  end

  def generate_qr_code
    qr_code = RQRCode::QRCode.new(self.otp_provisioning_uri)
    qr_code.as_svg(module_size: 6)
  end

  def validate_and_consume_otp!(otp_attempt)
    totp = ROTP::TOTP.new(self.otp_secret);
    totp.verify(otp_attempt, drift_behind: 30)
  end

  def name
    email.split("@").first.capitalize
  end

end
