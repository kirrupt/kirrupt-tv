defmodule KirruptTv.TimeWastedController do
  use KirruptTv.Web, :controller

  plug(KirruptTv.Plugs.Authenticate)
  plug(KirruptTv.Plugs.Authenticated)

  alias Model.User

  def index(conn, _params) do
    render(
      conn,
      "time_wasted.html",
      Map.merge(User.time_wasted(conn.assigns[:current_user]), %{title: "Time wasted"})
    )
  end
end
