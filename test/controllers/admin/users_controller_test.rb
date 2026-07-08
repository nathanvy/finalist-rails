require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = User.create!(
      username: "admin-user",
      password: "admin-password",
      password_confirmation: "admin-password",
      admin: true
    )

    @target_user = User.create!(
      username: "target-user",
      password: "old-password",
      password_confirmation: "old-password"
    )

    @non_admin = User.create!(
      username: "non-admin-user",
      password: "non-admin-password",
      password_confirmation: "non-admin-password"
    )
  end

  test "admin can view a user detail page with the password form" do
    log_in_as(@admin, password: "admin-password")

    get admin_user_path(@target_user)

    assert_response :success
    assert_select "h1", "User: #{@target_user.username}"
    assert_select "form[action=?]", set_password_admin_user_path(@target_user)
    assert_select "input[name=?]", "user[password]"
    assert_select "input[name=?]", "user[password_confirmation]"
  end

  test "admin can set a user's password" do
    log_in_as(@admin, password: "admin-password")
    old_digest = @target_user.password_digest

    post set_password_admin_user_path(@target_user), params: {
      user: {
        password: "new-password",
        password_confirmation: "new-password"
      }
    }

    assert_redirected_to admin_user_path(@target_user)
    follow_redirect!
    assert_match "Password updated.", response.body

    @target_user.reload
    assert_not_equal old_digest, @target_user.password_digest
    assert @target_user.authenticate("new-password")
    assert_not @target_user.authenticate("old-password")
  end

  test "admin cannot set a blank password" do
    log_in_as(@admin, password: "admin-password")
    old_digest = @target_user.password_digest

    post set_password_admin_user_path(@target_user), params: {
      user: {
        password: "",
        password_confirmation: ""
      }
    }

    assert_response :unprocessable_entity
    assert_equal old_digest, @target_user.reload.password_digest
    assert_select ".errormsg p", "New password can't be blank."
  end

  test "admin cannot set a password with mismatched confirmation" do
    log_in_as(@admin, password: "admin-password")
    old_digest = @target_user.password_digest

    post set_password_admin_user_path(@target_user), params: {
      user: {
        password: "new-password",
        password_confirmation: "different-password"
      }
    }

    assert_response :unprocessable_entity
    assert_equal old_digest, @target_user.reload.password_digest
    assert_select ".errormsg p", /Password confirmation/
  end

  test "logged out visitors cannot set passwords" do
    old_digest = @target_user.password_digest

    post set_password_admin_user_path(@target_user), params: {
      user: {
        password: "new-password",
        password_confirmation: "new-password"
      }
    }

    assert_redirected_to new_session_path
    assert_equal old_digest, @target_user.reload.password_digest
  end

  test "non-admin users cannot set passwords" do
    log_in_as(@non_admin, password: "non-admin-password")
    old_digest = @target_user.password_digest

    post set_password_admin_user_path(@target_user), params: {
      user: {
        password: "new-password",
        password_confirmation: "new-password"
      }
    }

    assert_response :forbidden
    assert_equal old_digest, @target_user.reload.password_digest
  end

  private

  def log_in_as(user, password:)
    post session_path, params: {
      username: user.username,
      password: password
    }

    assert_redirected_to lists_path
  end
end
