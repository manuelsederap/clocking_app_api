defmodule ClockingAppApiWeb.UserControllerTest do
  use ClockingAppApiWeb.ConnCase, async: true

  describe "Users Controller" do
    test "create users" do
      params = %{
        username: "testuser",
        email: "testuser@email.com"
      }
      conn = post(build_conn(), "/api/users", params)
      assert json_response(conn, 200)["email"] == "testuser@email.com"
    end

    test "update users" do
      user = insert(:user, username: "testuser", email: "testuser@email.com")

      params = %{
        user_id: user.id,
        username: "testuser_new",
        email: "testuser_new@email.com"
      }

      conn = put(build_conn(), "/api/users/#{user.id}", params)
      assert json_response(conn, 200)["message"] == "Successfully Updated"
    end

    test "delete users" do
      user = insert(:user, username: "testuser", email: "testuser@email.com")
      conn = delete(build_conn(), "/api/users/#{user.id}")
      assert json_response(conn, 200)["message"] == "Successfully Deleted"
    end

    test "get_user_by_username_and_email" do
      user = insert(:user, username: "testuser", email: "testuser@email.com")
      conn = get(build_conn(), "/api/users?email=#{user.email}&username=#{user.username}")
      assert json_response(conn, 200)["user_id"] == user.id
    end

    test "get_user_by_id" do
      user = insert(:user, username: "testuser", email: "testuser@email.com")
      conn = get(build_conn(), "/api/users/#{user.id}")
      assert json_response(conn, 200)["username"] == "testuser"
      assert json_response(conn, 200)["email"] == "testuser@email.com"
    end
  end
end
