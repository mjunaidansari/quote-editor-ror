require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "name" do
    assert_equal "Accountant", user(:accountant).name
  end
end
