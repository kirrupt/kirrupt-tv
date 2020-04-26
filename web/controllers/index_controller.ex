defmodule KirruptTv.IndexController do
  use KirruptTv.Web, :controller

  def index(conn, _params) do
    conn |> Phoenix.Controller.redirect(to: recent_path(conn, :index))
  end
end
