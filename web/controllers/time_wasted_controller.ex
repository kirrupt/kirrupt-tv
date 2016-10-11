defmodule KirruptTv.TimeWastedController do
  use KirruptTv.Web, :controller

  plug KirruptTv.Plugs.Authenticate
  plug KirruptTv.Plugs.Authenticated

  def index(conn, _params) do
    render conn, "time_wasted.html", %{title: "Time wasted"}
  end
end
