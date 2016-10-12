defmodule KirruptTv.PageController do
  use KirruptTv.Web, :controller

  plug KirruptTv.Plugs.Authenticate

  # alias KirruptTv.Show

  def search(_conn, _params) do

  end

  def search_kirrupt(conn, params) do
    conn
    |> put_layout(false)
    |> render("search_results.html", %{shows: Model.Show.find_shows_on_kirrupt(params["name"])})
  end

  def search_tvmaze(conn, _params) do
    # TODO
  end
end
