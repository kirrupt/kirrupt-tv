defmodule KirruptTv.RecentController do
  use KirruptTv.Web, :controller
  use Timex

  plug(KirruptTv.Plugs.Authenticate)

  alias Model.User

  def index(conn, _params) do
    render(conn, "recent.html", User.overview(conn.assigns[:current_user]))
  end
end
