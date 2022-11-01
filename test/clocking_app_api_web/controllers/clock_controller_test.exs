defmodule ClockingAppApiWeb.ClockControllerTest do
  use ClockingAppApiWeb.ConnCase, async: true

  describe "Clock Controller" do
    test "clock out users" do
      user = insert(:user, username: "testuser", email: "testuser@email.com")
      clock = insert(:clock, user_id: user.id, time: "2019-12-31 09:14:28", status: true)
      clock = insert(:clock, user_id: user.id, time: "2019-12-31 09:20:28", status: true)

      params = %{
        user_id: user.id,
        time: "2019-12-31 18:15:28",
        status: "true"
      }
      conn = post(build_conn(), "/api/clocks/#{user.id}", params)
      assert json_response(conn, 200)["time"] == "2019-12-31T18:15:28"
      assert json_response(conn, 200)["status"] == false
    end

    test "clock in users" do
      user = insert(:user, username: "testuser", email: "testuser@email.com")
      clock = insert(:clock, user_id: user.id, time: "2019-12-31 18:14:28", status: false)

      params = %{
        user_id: user.id,
        time: "2020-01-01 09:15:28",
        status: "true"
      }
      conn = post(build_conn(), "/api/clocks/#{user.id}", params)
      assert json_response(conn, 200)["time"] == "2020-01-01T09:15:28"
      assert json_response(conn, 200)["status"] == true
    end

    test "clock users" do
      user = insert(:user, username: "testuser", email: "testuser@email.com")
      clock = insert(:clock, user_id: user.id, time: "2019-12-31 18:14:28", status: false)
      clock = insert(:clock, user_id: user.id, time: "2019-12-31 09:14:28", status: true)
      clock = insert(:clock, user_id: user.id, time: "2019-12-30 18:14:28", status: false)
      clock = insert(:clock, user_id: user.id, time: "2019-12-30 09:14:28", status: true)

      conn = get(build_conn(), "/api/clocks/#{user.id}")
      assert json_response(conn, 200)
    end
  end
end
