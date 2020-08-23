# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :organize_me,
  ecto_repos: [OrganizeMe.Repo]

# Configures the endpoint
config :organize_me, OrganizeMeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Gd1Z1n3ul5fCj15P1NI2ANIj0l6ZonqQwA3qU1JX6ot4vTVNqczIOVvD5r7pf+up",
  render_errors: [view: OrganizeMeWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: OrganizeMe.PubSub,
  live_view: [signing_salt: "kZNvJkOy"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Pow auth config
config :organize_me, :pow,
  user: OrganizeMe.Users.User,
  repo: OrganizeMe.Repo,
  web_module: OrganizeMeWeb

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
