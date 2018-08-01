defmodule KirruptTv.EpisodeView do
  use KirruptTv.Web, :view

  def render("mark_as_watched.json", %{success: success}) do
    %{success: success}
  end

  def render("mark_as_unwatched.json", %{success: success}) do
    %{success: success}
  end
end
