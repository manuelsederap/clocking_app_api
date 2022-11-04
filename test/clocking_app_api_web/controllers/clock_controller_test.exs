defmodule ClockingAppApiWeb.ClockControllerTest do
  use ClockingAppApiWeb.ConnCase, async: true

  describe "Clock Controller" do
    test "clock out users" do
      user = insert(:user, username: "testuser", email: "testuser@email.com")
      insert(:clock, user_id: user.id, time: "2019-12-31 09:14:28", status: true)
      insert(:clock, user_id: user.id, time: "2019-12-31 09:20:28", status: true)
      _wt2 = insert(:working_time, user_id: user.id, start: "2019-10-11 09:14:28", end: nil)
      _wt1 = insert(:working_time, user_id: user.id, start: "2019-10-11 09:14:28", end: "2023-11-07 09:14:28")

      params = %{
        user_id: user.id,
        time: "2019-12-31 18:15:28",
        status: "true"
      }

      conn = post(build_conn(), "/api/clocks/#{user.id}", params)
      assert json_response(conn, 200)["message"] == "Successfully Clock-Out"
    end

    test "clock in users" do
      user = insert(:user, username: "testuser", email: "testuser@email.com")
      insert(:clock, user_id: user.id, time: "2019-12-31 18:14:28", status: false)

      params = %{
        user_id: user.id,
        time: "2020-01-01 09:15:28",
        status: "true"
      }
      conn = post(build_conn(), "/api/clocks/#{user.id}", params)
      assert json_response(conn, 200)["message"] == "Successfully Clock-In"
    end

    test "clock users" do
      user = insert(:user, username: "testuser", email: "testuser@email.com")
      insert(:clock, user_id: user.id, time: "2019-12-31 18:14:28", status: false)
      insert(:clock, user_id: user.id, time: "2019-12-31 09:14:28", status: true)
      insert(:clock, user_id: user.id, time: "2019-12-30 18:14:28", status: false)
      insert(:clock, user_id: user.id, time: "2019-12-30 09:14:28", status: true)

      conn = get(build_conn(), "/api/clocks/#{user.id}")
      assert json_response(conn, 200)
    end

    test "get all clocks" do
      user = insert(:user, username: "testuser", email: "testuser@email.com")
      insert(:clock, user_id: user.id, time: "2019-12-31 18:14:28", status: false)
      insert(:clock, user_id: user.id, time: "2019-12-31 09:14:28", status: true)
      insert(:clock, user_id: user.id, time: "2019-12-30 18:14:28", status: false)
      insert(:clock, user_id: user.id, time: "2019-12-30 09:14:28", status: true)

      conn = get(build_conn(), "/api/clocks/all_clocks")
      assert List.first(json_response(conn, 200))["user_id"] == user.id
    end
  end
end
