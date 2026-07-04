require "test_helper"

class SettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      username: "settings-user",
      password: "old-password",
      password_confirmation: "old-password"
    )
  end

  test "requires login" do
    get settings_path

    assert_redirected_to new_session_path
  end

  test "shows settings to logged in users" do
    log_in_as(@user)

    get settings_path

    assert_response :success
    assert_select "h1", "Settings"
    assert_select "a", text: "Settings"
  end

  test "changes password when current password matches" do
    log_in_as(@user)

    patch settings_path, params: {
      user: {
        current_password: "old-password",
        password: "new-password",
        password_confirmation: "new-password"
      }
    }

    assert_redirected_to settings_path
    follow_redirect!
    assert_match "Password updated.", response.body
    assert @user.reload.authenticate("new-password")
    assert_not @user.authenticate("old-password")
  end

  test "does not change password when current password is wrong" do
    log_in_as(@user)
    old_digest = @user.password_digest

    patch settings_path, params: {
      user: {
        current_password: "wrong-password",
        password: "new-password",
        password_confirmation: "new-password"
      }
    }

    assert_response :unprocessable_entity
    assert_equal old_digest, @user.reload.password_digest
    assert_match "Current password is incorrect.", response.body
  end

  test "does not change password when new password is blank" do
    log_in_as(@user)
    old_digest = @user.password_digest

    patch settings_path, params: {
      user: {
        current_password: "old-password",
        password: "",
        password_confirmation: ""
      }
    }

    assert_response :unprocessable_entity
    assert_equal old_digest, @user.reload.password_digest
    assert_match "New password can't be blank.", response.body
  end

  test "does not change password when confirmation does not match" do
    log_in_as(@user)
    old_digest = @user.password_digest

    patch settings_path, params: {
      user: {
        current_password: "old-password",
        password: "new-password",
        password_confirmation: "different-password"
      }
    }

    assert_response :unprocessable_entity
    assert_equal old_digest, @user.reload.password_digest
    assert_match "Password confirmation", response.body
  end

  private

  def log_in_as(user)
    post session_path, params: {
      username: user.username,
      password: "old-password"
    }

    assert_redirected_to lists_path
  end
end
