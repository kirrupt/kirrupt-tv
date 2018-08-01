defmodule KirruptTv.Api.V2.ShowView do
  use KirruptTv.Web, :view

  import KirruptTv.GlobalHelpers

  def render("index.json", %{data: %{shows: shows, ignored_show_ids: ignored_show_ids}}) do
    shows
    |> Enum.map(fn(show) ->
      map_show(show, ignored_show_ids)
    end)
  end

  def render("updated_dates.json", %{data: %{shows: shows, episodes: episodes}}) do
    shows
    |> Enum.map(fn([show_id, last_updated]) ->
      %{
        id: show_id,
        updated_at: last_updated |> DateTime.to_iso8601,
        episodes: episodes
                  |> Enum.reject(fn([_e_id, e_show_id, _e_last_updated]) -> e_show_id != show_id end)
                  |> Enum.map(fn([e_id, _e_show_id, e_last_updated]) ->
                    %{
                      id: e_id,
                      updated_at: e_last_updated |> DateTime.to_iso8601,
                    }
                  end)
      }
    end)
  end

  def render("sync_ignored.json", %{data: %{user_shows: user_shows}}) do
    user_shows
    |> Enum.map(fn(us) ->
      %{
        show_id: us.show_id,
        ignored: us.ignored,
        updated_at: us.modified |> DateTime.to_iso8601
      }
    end)
  end

  def render("episodes.json", %{data: %{episodes: episodes}}) do
    episodes
    |> Enum.map(fn(episode) ->
      %{
        id: episode.id,
        show_id: episode.show_id,
        airdate: if episode.airdate do DateTime.to_iso8601(episode.airdate) end,
        episode: episode.episode,
        season: episode.season,
        title: episode.title,
        tvrage_url: episode.tvrage_url,
        updated_at: episode.last_updated |> DateTime.to_iso8601
      }
    end)
  end

  def render("episodes_full.json", %{data: %{episodes: episodes}}) do
    episodes
    |> Enum.map(fn(episode) ->
      %{
        id: episode.id,
        show_id: episode.show_id,
        airdate: if episode.airdate do DateTime.to_iso8601(episode.airdate) end,
        episode: episode.episode,
        season: episode.season,
        screencap: episode.screencap |> img_prefix,
        title: episode.title,
        tvrage_url: episode.tvrage_url,
        summary: episode.summary,
        updated_at: episode.last_updated |> DateTime.to_iso8601
      }
    end)
  end

  def render("add_external_show.json", %{data: data}) do
    cond do
      data[:error] -> data
      true -> map_show(data[:show], [])
    end
  end

  def render("add_show.json", %{data: data}) do
    data
  end

  def render("update_any_show.json", %{data: data}) do
    map_show(data[:show], [])
  end

  defp map_show(show, ignored_show_ids) do
    %{
      id: show.id,
      added: show.added |> DateTime.to_iso8601,
      airday: show.airday,
      airtime: show.airtime,
      started: if show.started do Date.to_iso8601(show.started) end,
      ended: if show.ended do Date.to_iso8601(show.ended) end,
      fixed_background: show.fixed_background |> thumb("backgroundthumb"),
      fixed_banner: show.fixed_banner |> img_prefix,
      fixed_thumb: show.fixed_thumb |> thumb("cardthumb"),
      picture_url: show.picture_url |> img_prefix,
      thumbnail_url: show.thumbnail_url |> img_prefix,
      genres: show.genres |> Enum.map(fn(genre) -> genre.name end),
      name: show.name,
      runtime: show.runtime,
      status: show.status,
      summary: show.summary,
      tvrage_url: show.tvrage_url,
      year: show.year,
      ignored: Enum.member?(ignored_show_ids, show.id),
      updated_at: show.last_updated |> DateTime.to_iso8601
    }
  end
end
