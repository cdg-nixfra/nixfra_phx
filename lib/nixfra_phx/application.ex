defmodule NixfraPhx.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      NixfraPhxWeb.Telemetry,
      # Start the Ecto repository
      NixfraPhx.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: NixfraPhx.PubSub},
      # Start Finch
      {Finch, name: NixfraPhx.Finch},
      # Start the Endpoint (http/https)
      NixfraPhxWeb.Endpoint
      # Start a worker by calling: NixfraPhx.Worker.start_link(arg)
      # {NixfraPhx.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NixfraPhx.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    NixfraPhxWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
