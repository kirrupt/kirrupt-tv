defmodule KirruptTv.Parser.TVMaze do
  require Logger
  use Timex

  def process_response_body(body) do
    case body |> Jason.decode() do
      {:ok, data} ->
        data

      {:error, _} ->
        Logger.error("Could not parse response body")
        nil
    end
  end

  defp get_show_json(url) do
    Logger.info("Processing #{url}")
    response = HTTPoison.get(url)

    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        process_response_body(body)

      _ ->
        Logger.error("Could not access #{response} #{url}")
        nil
    end
  end

  defp remove_html(nil), do: nil

  defp remove_html(text) do
    HtmlSanitizeEx.strip_tags(text)
  end

  defp get_year_from_date(date_string) do
    case Timex.parse(date_string, "{YYYY}-{0M}-{0D}") do
      {:ok, date} ->
        date.year

      {:error, _} ->
        Logger.error("Could not parse date")
        nil
    end
  end

  def show_info(show_id) do
    if data = get_show_json("https://api.tvmaze.com/shows/#{show_id}?embed[]=episodes") do
      parse_show_data(data)
    end
  end

  def parse_year(result, %{"premiered" => premiered}) do
    if year = get_year_from_date(premiered) do
      Map.put(result, :year, year)
    else
      result
    end
  end

  def parse_year(result, _), do: result

  def parse_image(result, %{"image" => %{"original" => original}}),
    do: Map.put(result, :image, original)

  def parse_image(result, _), do: result

  def parse_network_country(result, %{"code" => code}), do: Map.put(result, :origin_country, code)
  def parse_network_country(result, _), do: result

  def parse_network_timezone(result, %{"timezone" => timezone}),
    do: Map.put(result, :timezone, timezone)

  def parse_network_timezone(result, _), do: result

  def parse_network(result, %{"network" => %{"country" => country}}) do
    result
    |> parse_network_country(country)
    |> parse_network_timezone(country)
  end

  def parse_network(result, _), do: result

  def parse_schedule_time(result, %{"time" => time}), do: Map.put(result, :airtime, time)
  def parse_schedule_time(result, _), do: result

  def parse_schedule_day(result, %{"days" => [head | _]}), do: Map.put(result, :airday, head)
  def parse_schedule_day(result, _), do: result

  def parse_schedule(result, %{"schedule" => schedule}) do
    result
    |> parse_schedule_time(schedule)
    |> parse_schedule_day(schedule)
  end

  def parse_schedule(result, _), do: result

  def parse_premiered(result, %{"premiered" => premiered}),
    do: Map.put(result, :started, premiered)

  def parse_premiered(result, _), do: result

  def parse_genres(result, %{"genres" => genres}), do: Map.put(result, :genres, genres)
  def parse_genres(result, _), do: result

  def parse_episode_image(result, %{"image" => %{"original" => original}}),
    do: Map.put(result, :screencap, original)

  def parse_episode_image(result, _), do: result

  def parse_episode(ep) do
    %{
      episode: ep["number"],
      season: ep["season"],
      airdate: ep["airdate"],
      url: ep["url"],
      title: ep["name"],
      summary: remove_html(ep["summary"])
    }
    |> parse_episode_image(ep)
  end

  def parse_embedded(result, %{"_embedded" => %{"episodes" => episodes}}) do
    Map.put(
      result,
      :episodes,
      episodes |> Enum.reduce([], fn ep, acc -> acc ++ [parse_episode(ep)] end)
    )
  end

  def parse_embedded(result, _), do: result

  def parse_show_data(data) do
    %{
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
    |> parse_year(data)
    |> parse_image(data)
    |> parse_network(data)
    |> parse_schedule(data)
    |> parse_premiered(data)

    # missing fields on TVmaze:
    # - ended

    |> parse_genres(data)
    |> parse_embedded(data)
  end

  def search(name) do
    if data = get_show_json("https://api.tvmaze.com/search/shows?q=#{URI.encode(name)}") do
      Enum.reduce(data, [], fn show, acc ->
        cond do
          show["show"] ->
            acc ++ [parse_show_data(show["show"])]

          true ->
            acc
        end
      end)
    else
      []
    end
  end
end
