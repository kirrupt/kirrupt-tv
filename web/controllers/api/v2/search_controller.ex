defmodule KirruptTv.Api.V2.SearchController do
  use KirruptTv.Web, :controller

  plug KirruptTv.Plugs.Authenticate

  def search_kirrupt(conn, %{"name" => name}) do
    render conn, "search_kirrupt.json", data: %{shows: Model.Show.find_shows_on_kirrupt(name)}
  end

  def search_external(conn, %{"name" => name}) do
    render conn, "search_external.json", data: %{shows: Model.Show.find_shows_on_tvmaze(name)}
  end
end
