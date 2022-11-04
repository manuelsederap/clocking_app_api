defmodule ClockingAppApiWeb.WorkingTimeControllerTest do
  use ClockingAppApiWeb.ConnCase, async: true

  describe "Working Time Controller" do

    test "create working time" do
      user = insert(:user, username: "testuser", email: "testuser@email.com")
      params = %{
        start: "2019-12-31 09:14:28",
        end: "2022-12-31 09:14:28"
      }
      conn = post(build_conn(), "/api/workingtimes/#{user.id}", params)
      assert json_response(conn, 200)["start_date"] == "2019-12-31T09:14:28"
      assert json_response(conn, 200)["end_date"] == "2022-12-31T09:14:28"
    end

    test "update working time" do
      user = insert(:user, username: "testuser", email: "testuser@email.com")
      wt = insert(:working_time, user_id: user.id, start: "2019-10-11 09:14:28", end: "2023-11-07 09:14:28")

      params = %{
        start: "2021-10-31 09:14:28",
        end: "2023-11-05 09:14:00"
      }

      conn = put(build_conn(), "/api/workingtimes/#{wt.id}", params)
      assert json_response(conn, 200)["message"] == "Successfully Updated"
    end

    test "delete working time" do
      user = insert(:user, username: "testuser", email: "testuser@email.com")
      wt = insert(:working_time, user_id: user.id, start: "2019-10-11 09:14:28", end: "2023-11-07 09:14:28")

      conn = delete(build_conn(), "/api/workingtimes/#{wt.id}")
      assert json_response(conn, 200)["message"] == "Successfully Deleted"
    end

    test "get_working_times" do
      user = insert(:user, username: "testuser", email: "testuser@email.com")
      wt = insert(:working_time, user_id: user.id, start: "2019-10-11 09:14:28", end: "2023-11-07 09:14:28")
      conn = get(build_conn(), "/api/workingtimes/#{user.id}?start=#{wt.start}&end=#{wt.end}")
      assert List.first(json_response(conn, 200))["start"] == "2019-10-11T09:14:28"
      assert List.first(json_response(conn, 200))["end"] == "2023-11-07T09:14:28"
    end

    test "get_working_time" do
      user = insert(:user, username: "testuser", email: "testuser@email.com")
      wt = insert(:working_time, user_id: user.id, start: "2019-10-11 09:14:28", end: "2023-11-07 09:14:28")

      conn = get(build_conn(), "/api/workingtimes/#{user.id}/#{wt.id}")
      assert json_response(conn, 200)["start_date"] == "2019-10-11T09:14:28"
      assert json_response(conn, 200)["end_date"] == "2023-11-07T09:14:28"
    end

    test "get all working times" do
      user1 = insert(:user, username: "testuser", email: "testuser@email.com")
      user2 = insert(:user, username: "testuser2", email: "testuser2@email.com")
      _wt1 = insert(:working_time, user_id: user1.id, start: "2019-10-11 09:14:28", end: "2023-11-07 09:14:28")
      _wt2 = insert(:working_time, user_id: user2.id, start: "2020-10-11 09:14:28", end: "2023-11-07 09:14:28")

      conn = get(build_conn(), "/api/workingtimes/all_working_times")
      assert List.first(json_response(conn, 200))["user_id"] == user1.id
    end
  end
end
