defmodule KirruptTv.ShowView do
  use KirruptTv.Web, :view
  import KirruptTv.DateHelpers
  import KirruptTv.GlobalHelpers

  def episode_watched?(episode, watched_episodes) do
    watched_episodes
    |> Enum.member? episode.id
  end
end
