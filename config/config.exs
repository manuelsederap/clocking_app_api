# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :clocking_app_api,
  ecto_repos: [ClockingAppApi.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :clocking_app_api, ClockingAppApiWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: ClockingAppApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: ClockingAppApi.PubSub,
  live_view: [signing_salt: "H54CS5uC"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :clocking_app_api, ClockingAppApi.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
