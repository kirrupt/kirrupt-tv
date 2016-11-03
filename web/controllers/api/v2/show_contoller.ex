defmodule KirruptTv.Api.V2.ShowController do
  use KirruptTv.Web, :controller

  plug KirruptTv.Plugs.Authenticate

  def index(conn, params) do
    show_ids = cond do
      params["show_ids"] -> params["show_ids"]
      conn.assigns[:current_user] -> Model.User.get_user_show_ids(conn.assigns[:current_user])
      true -> []
    end

    ignored_show_ids = cond do
      conn.assigns[:current_user] -> Model.User.get_user_ignored_show_ids(conn.assigns[:current_user])
      true -> []
    end

    if params["except_show_ids"] do
      show_ids = Enum.reject(show_ids, fn(id) -> Enum.member?(params["except_show_ids"], id) end)
    end

    render conn, "index.json", data: %{shows: Model.Show.get_shows(show_ids), ignored_show_ids: ignored_show_ids}
  end

  def updated_dates(conn, %{"show_ids" => show_ids}) do
    render conn, "updated_dates.json", data: %{shows: Model.Show.get_show_updated_dates(show_ids), episodes: Model.Show.get_show_episodes_updated_dates(show_ids)}
  end

  def episodes(conn, %{"show_ids" => show_ids}) do
    render conn, "episodes.json", data: %{episodes: Model.Show.get_show_episodes(show_ids)}
  end

  def episodes_full(conn, %{"show_ids" => show_ids}) do
    render conn, "episodes_full.json", data: %{episodes: Model.Show.get_show_episodes(show_ids)}
  end
end
