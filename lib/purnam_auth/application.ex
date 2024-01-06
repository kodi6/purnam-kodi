defmodule PurnamAuth.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PurnamAuthWeb.Telemetry,
      PurnamAuth.Repo,
      {DNSCluster, query: Application.get_env(:purnam_auth, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PurnamAuth.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PurnamAuth.Finch},
      # Start a worker by calling: PurnamAuth.Worker.start_link(arg)
      # {PurnamAuth.Worker, arg},
      # Start to serve requests, typically the last entry
      PurnamAuthWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PurnamAuth.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PurnamAuthWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
