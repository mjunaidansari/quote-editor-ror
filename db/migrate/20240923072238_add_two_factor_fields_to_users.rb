class AddTwoFactorFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :otp_secret, :string
    add_column :users, :otp_enabled, :boolean
  end
end
