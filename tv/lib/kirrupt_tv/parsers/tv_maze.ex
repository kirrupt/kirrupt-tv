defmodule KirruptTv.Parser.TVMaze do
  require Logger
  use Timex

  defp process_response_body(body) do
    case body |> Poison.decode do
       {:ok, data} -> data
       {:error, _} -> Logger.error("Could not parse response body"); nil
    end
  end

  defp get_show_json(url) do
    Logger.info("Processing #{url}")
    response = HTTPotion.get url

    case response do
      %{status_code: 200, body: body} -> process_response_body(body)
      _ -> Logger.error("Could not access #{url}"); nil
    end
  end

  defp remove_html(nil), do: nil
  defp remove_html(text) do
    HtmlSanitizeEx.strip_tags(text)
  end

  defp get_year_from_date(date_string) do
    case Timex.parse(date_string, "{YYYY}-{0M}-{0D}") do
      {:ok, date} -> date.year
      {:error, _} -> Logger.error("Could not parse date"); nil
    end
  end

  def show_info(show_id) do
    if data = get_show_json("http://api.tvmaze.com/shows/#{show_id}?embed[]=episodes") do
      parse_show_data(data)
    end
  end

  def parse_show_data(data) do
    result = %{
      tvmaze_id: data["id"],
      name: data["name"],
      url: data["url"],
      runtime: data["runtime"],
      status: data["status"],
      summary: remove_html(data["summary"]),
      # defaults
      origin_country: nil,
      timezone: nil
    }

    if year = get_year_from_date(data["premiered"]) do
      result = Map.merge(result, %{year: year})
    end

    if data["image"] && data["image"]["original"] do
      result = Map.merge(result, %{image: data["image"]["original"]})
    end

    if data["network"] && data["network"]["country"] do
      if data["network"]["country"]["code"] do
        result = Map.merge(result, %{origin_country: data["network"]["country"]["code"]})
      end

      if data["network"]["country"]["timezone"] do
        result = Map.merge(result, %{timezone: data["network"]["country"]["timezone"]})
      end
    end

    if data["schedule"] do
      if data["schedule"]["time"] do
        result = Map.merge(result, %{airtime: data["schedule"]["time"]})
      end

      if data["schedule"]["days"] && (day = data["schedule"]["days"] |> List.first) do
        result = Map.merge(result, %{airday: day})
      end
    end

    if data["premiered"] do
      result = Map.merge(result, %{started: data["premiered"]})
    end

    # missing fields on TVmaze:
    # - ended

    if data["genres"] do
      result = Map.merge(result, %{genres: data["genres"]})
    end

    if data["_embedded"] && data["_embedded"]["episodes"] do
      result = Map.merge(result, %{
        episodes: data["_embedded"]["episodes"]
          |> Enum.reduce([], fn(ep, acc) ->
            episode = %{
              episode: ep["number"],
              season: ep["season"],
              airdate: ep["airdate"],
              url: ep["url"],
              title: ep["name"],
              summary: remove_html(ep["summary"])
            }

            if ep["image"] && ep["image"]["original"] do
              episode = Map.merge(episode, %{screencap: ep["image"]["original"]})
            end

            acc ++ [episode]
          end)
      })
    end

    result
  end

  def search(name) do
    if data = get_show_json("http://api.tvmaze.com/search/shows?q=#{URI.encode(name)}") do
      Enum.reduce(data, [], fn(show, acc) ->
        cond do
          show["show"] ->
            acc ++ [parse_show_data(show["show"])]
          true -> acc
        end
      end)
    else
      []
    end
  end
end