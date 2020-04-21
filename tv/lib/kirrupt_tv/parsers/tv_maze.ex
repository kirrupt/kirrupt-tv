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

  defp parse_year(result, data) do
    if year = get_year_from_date(data["premiered"]) do
      Map.put(result, :year, year)
    else
      result
    end
  end

  defp parse_image(result, data) do
    if data["image"] && data["image"]["original"] do
      Map.put(result, :image, data["image"]["original"])
    else
      result
    end
  end

  defp parse_network_country(result, data) do
    if data["network"]["country"]["code"] do
      Map.put(result, :origin_country, data["network"]["country"]["code"])
    else
      result
    end
  end

  defp parse_network_timezone(result, data) do
    if data["network"]["country"]["timezone"] do
      Map.put(result, :timezone, data["network"]["country"]["timezone"])
    else
      result
    end
  end

  defp parse_network(result, data) do
    if data["network"] && data["network"]["country"] do
      result = parse_network_country(result, data)
      parse_network_timezone(result, data)
    else
      result
    end
  end

  defp parse_schedule_time(result, data) do
    if data["schedule"]["time"] do
      Map.put(result, :airtime, data["schedule"]["time"])
    else
      result
    end
  end

  defp parse_schedule_day(result, data) do
    if data["schedule"]["days"] do
      if day = data["schedule"]["days"] |> List.first do
        Map.put(result, :airday, day)
      else
        result
      end
    else
      result
    end
  end

  defp parse_schedule(result, data) do
    if data["schedule"] do
      result = parse_schedule_time(result, data)
      parse_schedule_day(result, data)
    end
  end

  defp parse_premiered(result, data) do
    if data["premiered"] do
      Map.put(result, :started, data["premiered"])
    else
      result
    end
  end

  defp parse_genres(result, data) do
    if data["genres"] do
      Map.put(result, :genres, data["genres"])
    else
      result
    end
  end

  defp parse_episode_image(parsed, ep) do
    if ep["image"] && ep["image"]["original"] do
      Map.put(parsed, :screencap, ep["image"]["original"])
    else
      parsed
    end
  end

  defp parse_episode(ep) do
    parsed = %{
      episode: ep["number"],
      season: ep["season"],
      airdate: ep["airdate"],
      url: ep["url"],
      title: ep["name"],
      summary: remove_html(ep["summary"])
    }

    parse_episode_image(parsed, ep)
  end

  defp parse_embedded(result, data) do
    if data["_embedded"] && data["_embedded"]["episodes"] do
      Map.put(result, :episodes,
              data["_embedded"]["episodes"] |> Enum.reduce([], fn(ep, acc) -> acc ++ [parse_episode(ep)] end))
    else
      result
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

    result = parse_year(result, data)
    result = parse_image(result, data)
    result = parse_network(result, data)
    result = parse_schedule(result, data)
    result = parse_premiered(result, data)

    # missing fields on TVmaze:
    # - ended

    result = parse_genres(result, data)
    parse_embedded(result, data)
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
