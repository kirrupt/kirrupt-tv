defmodule KirruptTv.RecentController do
  use KirruptTv.Web, :controller
  use Timex

  plug KirruptTv.Plugs.Authenticated

  alias Model.User

  def index(conn, _params) do
    render conn, "recent.html", User.public_overview
  end
end
