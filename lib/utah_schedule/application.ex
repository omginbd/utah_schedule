defmodule UtahSchedule.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    UtahSchedule.Release.migrate()

    children = [
      # Start the Telemetry supervisor
      UtahScheduleWeb.Telemetry,
      # Start the Ecto repository
      UtahSchedule.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: UtahSchedule.PubSub},
      # Start Finch
      {Finch, name: UtahSchedule.Finch},
      # Start the Endpoint (http/https)
      UtahScheduleWeb.Endpoint,
      {Oban, Application.fetch_env!(:utah_schedule, Oban)}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UtahSchedule.Supervisor]
    :ets.new(:games, [:set, :named_table, :public])
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    UtahScheduleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
