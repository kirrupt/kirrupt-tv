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

  def add_external_show(conn, %{"external_id" => external_id}) do
    if show = Model.Show.add_tvmaze_show(external_id) do
      render conn, "add_external_show.json", data: %{show: show |> Repo.preload([:genres])}
    else
      conn
      |> put_status(400)
      |> render "add_external_show.json", data: %{error: "COULD_NOT_ADD_EXTERNAL_SHOW"}
    end
  end

  def add_shows(conn, %{"id" => id}) do
    if Model.User.add_show(conn.assigns[:current_user], Model.Show.find_by_url_or_id(id)) do
      render conn, "add_show.json", data: %{success: true}
    else
      conn
      |> put_status(400)
      |> render "add_show.json", data: %{error: "COULD_NOT_ADD_SHOW"}
    end
  end
end
