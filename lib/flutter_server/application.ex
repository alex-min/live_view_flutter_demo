defmodule FlutterServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      FlutterServerWeb.Telemetry,
      # Start the Ecto repository
      FlutterServer.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: FlutterServer.PubSub},
      # Start Finch
      {Finch, name: FlutterServer.Finch},
      # Start the Endpoint (http/https)
      FlutterServerWeb.Endpoint
      # Start a worker by calling: FlutterServer.Worker.start_link(arg)
      # {FlutterServer.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FlutterServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FlutterServerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
