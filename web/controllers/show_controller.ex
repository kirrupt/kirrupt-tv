defmodule KirruptTv.ShowController do
  use KirruptTv.Web, :controller

  plug(KirruptTv.Plugs.Authenticate)
  plug(KirruptTv.Plugs.Authenticated when action in [:ignore, :my_shows])
  plug(KirruptTv.Plugs.Authenticated.Admin when action in [:update])

  alias Model.Show
  import KirruptTv.Helpers.BackgroundHelpers

  def index(conn, %{"name" => name}) do
    render_show_details(conn, name)
  end

  def season(conn, %{"name" => name, "season" => season}) do
    render_show_details(conn, name, season)
  end

  def list(conn, %{"name" => name}) do
    show_details = Show.show_list(name, conn.assigns[:current_user])

    if show_details do
      render(conn, "show-list.html", Map.merge(show_details, %{title: show_details[:show].name}))
    else
      redirect(conn, to: KirruptTv.Router.Helpers.recent_path(conn, :index))
    end
  end

  def ignore(conn, %{"name" => name}) do
    Model.Show.ignore_show(Model.Show.find_by_url_or_id(name), conn.assigns[:current_user])
    redirect(conn, to: KirruptTv.Router.Helpers.show_path(conn, :index, name))
  end

  def add(conn, _params) do
    render(conn, "add.html", %{title: "Add show"})
  end

  def add_to_my_shows(conn, %{"name" => name}) do
    if Model.User.add_show(conn.assigns[:current_user], Model.Show.find_by_url_or_id(name)) do
      redirect(conn, to: KirruptTv.Router.Helpers.show_path(conn, :index, name))
    else
      redirect(conn, to: KirruptTv.Router.Helpers.recent_path(conn, :index))
    end
  end

  def update(conn, %{"name" => name}) do
    if show = Model.Show.find_by_url_or_id(name) do
      Model.Show.update_show_and_episodes(show)
      redirect(conn, to: KirruptTv.Router.Helpers.show_path(conn, :index, name))
    else
      redirect(conn, to: KirruptTv.Router.Helpers.recent_path(conn, :index))
    end
  end

  def add_tvmaze(conn, %{"tvmaze_id" => tvmaze_id}) do
    if show = Model.Show.add_tvmaze_show(tvmaze_id) do
      redirect(conn, to: KirruptTv.Router.Helpers.show_path(conn, :index, show.url || show.id))
    else
      redirect(conn, to: KirruptTv.Router.Helpers.recent_path(conn, :index))
    end
  end

  def my_shows(conn, _params), do: my_shows_response(conn, "my_shows")
  def my_shows_category(conn, %{"category" => category}), do: my_shows_response(conn, category)

  defp my_shows_response(conn, category) do
    category = category |> String.to_atom()
    shows = Model.User.get_user_shows(conn.assigns[:current_user])

    count = %{
      current: Enum.count(shows[:my_shows]),
      canceled: Enum.count(shows[:canceled]),
      ignored: Enum.count(shows[:ignored])
    }

    title =
      case category do
        :my_shows -> "My shows"
        :canceled -> "Canceled shows"
        :ignored -> "Ignored shows"
      end

    render(conn, "my-shows.html", %{
      count: count,
      shows: shows[category],
      category: category,
      title: title,
      background: random_background(shows[category])
    })
  end

  defp render_show_details(conn, id_or_url, season \\ nil) do
    show_details = Show.show(id_or_url, conn.assigns[:current_user], season)

    if show_details do
      render(conn, "show.html", Map.merge(show_details, %{title: show_details[:show].name}))
    else
      redirect(conn, to: KirruptTv.Router.Helpers.recent_path(conn, :index))
    end
  end
end
