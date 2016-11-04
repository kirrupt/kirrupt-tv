defmodule KirruptTv.Api.V2.ShowView do
  use KirruptTv.Web, :view


  def render("index.json", %{data: %{shows: shows, ignored_show_ids: ignored_show_ids}}) do
    shows
    |> Enum.map(fn(show) ->
      %{
        id: show.id,
        added: show.added |> DateTime.to_iso8601,
        airday: show.airday,
        airtime: show.airtime,
        started: if show.started do Date.to_iso8601(show.started) end,
        ended: if show.ended do Date.to_iso8601(show.ended) end,
        fixed_background: show.fixed_background,
        fixed_banner: show.fixed_banner,
        fixed_thumb: show.fixed_thumb,
        picture_url: show.picture_url,
        thumbnail_url: show.thumbnail_url,
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

  def render("episodes.json", %{data: %{episodes: episodes}}) do
    episodes
    |> Enum.map(fn(episode) ->
      %{
        id: episode.id,
        show_id: episode.show_id,
        airdate: episode.airdate |> DateTime.to_iso8601,
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
        airdate: episode.airdate |> DateTime.to_iso8601,
        episode: episode.episode,
        season: episode.season,
        screencap: episode.screencap,
        title: episode.title,
        tvrage_url: episode.tvrage_url,
        summary: episode.summary,
        updated_at: episode.last_updated |> DateTime.to_iso8601
      }
    end)
  end
end
