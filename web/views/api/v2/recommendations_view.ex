defmodule KirruptTv.Api.V2.RecommendationsView do
  use KirruptTv.Web, :view

  def render("recommendations.json", %{data: shows}) do
    shows
    |> Enum.map(fn show ->
      %{
        id: show.id,
        img: show |> Model.Show.show_thumb(),
        url: show.url
      }
    end)
  end
end
