defmodule KirruptTv.PageController do
  use KirruptTv.Web, :controller
  import KirruptTv.Helpers.BackgroundHelpers

  plug KirruptTv.Plugs.Authenticate

  def search(conn, params) do
    shows = Model.Show.search(params["q"], conn.assigns[:current_user])

    conn = if KirruptTv.Helpers.RequestHelpers.xhr?(conn) do
      conn |> put_layout(false)
    else
      conn
    end

    render(conn, "search.html", %{
      shows: shows,
      my_shows: Model.Show.filter_user_shows(shows, conn.assigns[:current_user]),
      background: random_background(shows),
      query: params["q"]
    })
  end

  def search_kirrupt(conn, params) do
    conn
    |> put_layout(false)
    |> render("search_results.html", %{shows: Model.Show.find_shows_on_kirrupt(params["name"]), tvmaze: false})
  end

  def search_tvmaze(conn, params) do
    conn
    |> put_layout(false)
    |> render("search_results.html", %{shows: Model.Show.find_shows_on_tvmaze(params["name"]), tvmaze: true})
  end
end
