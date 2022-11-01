defmodule ClockingAppApi.Repo do
  use Ecto.Repo,
    otp_app: :clocking_app_api,
    adapter: Ecto.Adapters.Postgres
end
