# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :calculator,
  ecto_repos: [Calculator.Repo]

# Configures the endpoint
config :calculator, CalculatorWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "j/x4R1bkhcCI73rqcsNTnV1ANnr4/sSn0lyRaq/RasX9mAO1epAZzrYysDWEeNBY",
  render_errors: [view: CalculatorWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Calculator.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "N/tAn34L"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
