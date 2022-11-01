defmodule ClockingAppApiWeb.Router do
  use ClockingAppApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ClockingAppApiWeb do
    pipe_through :api
    scope "/users" do
      post "/", UserController, :create_user
      put "/:user_id", UserController, :update_user
      delete "/:user_id", UserController, :delete_user
      get "/", UserController, :users
      get "/:user_id", UserController, :user
    end

    scope "/workingtimes" do
      post "/:user_id", WorkingTimeController, :create
      put "/:id", WorkingTimeController, :update
      delete "/:id", WorkingTimeController, :delete
      get "/:user_id", WorkingTimeController, :get_working_times
      get "/:user_id/:id", WorkingTimeController, :get_working_time
    end

    scope "/clocks" do
      post "/:user_id", ClockController, :clock_in
      get "/:user_id", ClockController, :get_user_clock
    end
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: ClockingAppApiWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
