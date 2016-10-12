defmodule KirruptTv.GenreController do
  use KirruptTv.Web, :controller
  use Timex

  plug KirruptTv.Plugs.Authenticate

  alias Model.Genre

  def index(conn, %{"name" => name}) do
    data = Genre.index(name)

    if data do
      render conn, "genre.html", data
    else
      conn |> Phoenix.Controller.redirect(to: recent_path(conn, :index)) |> halt
    end
  end
end
