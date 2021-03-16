defmodule KirruptTv.Api.V2.SearchView do
  use KirruptTv.Web, :view

  import KirruptTv.GlobalHelpers

  def render("search_kirrupt.json", %{data: %{shows: shows}}) do
    shows
    |> Enum.map(fn show ->
      %{
        id: show.id,
        name: show.name,
        status: show.status,
        started:
          if show.started do
            Date.to_iso8601(show.started)
          end,
        ended:
          if show.ended do
            Date.to_iso8601(show.ended)
          end,
        genres: show.genres |> Enum.map(fn genre -> genre.name end),
        summary: show.summary,
        tvrage_url: show.tvrage_url,
        picture_url: show.picture_url |> img_prefix,
        fixed_background: show.fixed_background |> img_prefix
      }
    end)
  end

  def render("search_external.json", %{data: %{shows: shows}}) do
    shows
    |> Enum.map(fn show ->
      %{
        external_id: show[:tvmaze_id],
        name: show[:name],
        status: show[:status],
        started: show[:started],
        ended: show[:ended],
        genres: show[:genres],
        summary: show[:summary],
        tvrage_url: show[:url],
        picture_url: show[:image]
      }
    end)
  end
end
