defmodule KirruptTv.ShowController do
  use KirruptTv.Web, :controller

  plug KirruptTv.Plugs.Authenticate
  plug KirruptTv.Plugs.Authenticated when action in [:ignore]

  alias Model.Show

  def index(conn, %{"name" => name}) do
    render_show_details(conn, name)
  end

  def season(conn, %{"name" => name, "season" => season}) do
    render_show_details(conn, name, season)
  end

  def list(conn, %{"name" => name}) do
    show_details = Show.show_list(name, conn.assigns[:current_user])
    if show_details do
      render conn, "show-list.html", Dict.merge(show_details, %{title: show_details[:show].name})
    else
      redirect conn, to: "/"
    end
  end

  def ignore(conn, %{"name" => name}) do
    Model.Show.ignore_show(Model.Show.find_by_url_or_id(name), conn.assigns[:current_user])
    redirect conn, to: KirruptTv.Router.Helpers.show_path(conn, :index, name)
  end

  defp render_show_details(conn, id_or_url, season \\ nil) do
    show_details = Show.show(id_or_url, conn.assigns[:current_user], season)
    if show_details do
      render conn, "show.html", Dict.merge(show_details, %{title: show_details[:show].name})
    else
      redirect conn, to: "/"
    end
  end
end
