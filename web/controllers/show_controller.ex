defmodule KirruptTv.ShowController do
  use KirruptTv.Web, :controller

  plug KirruptTv.Plugs.Authenticated

  alias Model.Show

  def index(conn, %{"name" => name}) do
    show_details = Show.show(name, conn.assigns[:current_user])
    if show_details do
      render conn, "show.html", Dict.merge(show_details, %{title: show_details[:show].name})
    else
      redirect conn, to: "/"
    end
  end
end
