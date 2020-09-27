defmodule OrganizeMe.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      OrganizeMe.Repo,
      OrganizeMeWeb.Telemetry,
      {Phoenix.PubSub, name: OrganizeMe.PubSub},
      OrganizeMeWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: OrganizeMe.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    OrganizeMeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
