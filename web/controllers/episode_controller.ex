defmodule KirruptTv.EpisodeController do
  use KirruptTv.Web, :controller

  plug(KirruptTv.Plugs.Authenticate)
  plug(KirruptTv.Plugs.Authenticated)

  alias Model.Episode

  def mark_as_watched(conn, %{"id" => id}) do
    success = Episode.mark_as_watched(id, conn.assigns[:current_user])
    render(conn, "mark_as_watched.json", success: success)
  end

  def mark_as_unwatched(conn, %{"id" => id}) do
    success = Episode.mark_as_unwatched(id, conn.assigns[:current_user])
    render(conn, "mark_as_unwatched.json", success: success)
  end
end
