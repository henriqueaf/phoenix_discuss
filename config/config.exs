# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :phoenix_discuss,
  ecto_repos: [PhoenixDiscuss.Repo]

# Configures the endpoint
config :phoenix_discuss, PhoenixDiscussWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "kkHq+LwuW1VdgJ/IWMLXa6LDBtCHRHKA/k2DbdjQuiFfSl2l9eyTEw492raWzZtg",
  render_errors: [view: PhoenixDiscussWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PhoenixDiscuss.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :ueberauth, Ueberauth,
  providers: [
    github: { Ueberauth.Strategy.Github, [default_scope: "user"] }
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")