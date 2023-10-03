defmodule UtahScheduleWeb.HealthController do
  use UtahScheduleWeb, :controller

  def show(conn, _) do
    Finch.build(:post, "https://ntfy.sh/michaelsutahutesschedule", [], "testing")
    |> Finch.request(UtahSchedule.Finch)

    Plug.Conn.send_resp(conn, 200, "OK")
  end
end
