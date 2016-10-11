defmodule KirruptTv.ShowController do
  use KirruptTv.Web, :controller

  plug KirruptTv.Plugs.Authenticate

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

  defp render_show_details(conn, id_or_url, season \\ nil) do
    show_details = Show.show(id_or_url, conn.assigns[:current_user], season)
    if show_details do
      render conn, "show.html", Dict.merge(show_details, %{title: show_details[:show].name})
    else
      redirect conn, to: "/"
    end
  end
end
