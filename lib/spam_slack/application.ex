defmodule SpamSlack.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      SpamSlackWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: SpamSlack.PubSub},
      # Start Finch
      {Finch, name: SpamSlack.Finch},
      # Start the Endpoint (http/https)
      SpamSlackWeb.Endpoint,
      # Start a worker by calling: SpamSlack.Worker.start_link(arg)
      # {SpamSlack.Worker, arg}
      SpamSlack.Reports.ReportServer
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SpamSlack.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SpamSlackWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
