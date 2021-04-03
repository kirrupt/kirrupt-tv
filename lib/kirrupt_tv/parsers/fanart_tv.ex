defmodule KirruptTv.Parser.FanartTV do
  require Logger
  use Timex

  defp process_response_body(body) do
    case body |> Jason.decode() do
      {:ok, data} ->
        data

      {:error, _} ->
        Logger.error("Could not parse response body")
        nil
    end
  end

  defp get_json(url) do
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

  def get_image_list(nil), do: nil

  def get_image_list(the_tv_db_id) do
    if data =
         get_json(
           "http://webservice.fanart.tv/v3/tv/#{the_tv_db_id}?api_key=#{
             Application.get_env(:kirrupt_tv, KirruptTv.Endpoint)[:fanart_key]
           }"
         ) do
      # available
      # clearlogo, hdtvlogo, seasonposter, tvthumb, showbackground, tvposter, tvbanner, clearart, hdclearart, seasonthumb, characterart, seasonbanner
      %{
        tvthumb: data["tvthumb"] && data["tvthumb"] |> Enum.map(fn x -> x["url"] end),
        showbackground:
          data["showbackground"] && data["showbackground"] |> Enum.map(fn x -> x["url"] end),
        tvbanner: data["tvbanner"] && data["tvbanner"] |> Enum.map(fn x -> x["url"] end)
      }
      |> Common.Map.compact()
    end
  end
end
