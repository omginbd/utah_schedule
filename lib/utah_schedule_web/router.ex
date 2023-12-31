defmodule UtahScheduleWeb.Router do
  use UtahScheduleWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", UtahScheduleWeb do
    pipe_through :api
    get "/health", HealthController, :show
  end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:utah_schedule, :dev_routes) do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      # forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
