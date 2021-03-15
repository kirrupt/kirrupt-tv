defmodule KirruptTv.Parser.TheTVDB do
  require Logger
  use Timex

  import SweetXml

  defp get_show_xml(url) do
    Logger.info("Processing #{url}")
    response = HTTPoison.get url

    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> body
      _ -> Logger.error("Could not access #{response} #{url}"); nil
    end
  end

  def get_show_id(show_name) do
    if data = get_show_xml("https://thetvdb.com/api/GetSeries.php?seriesname=#{URI.encode(show_name)}&language=en") do
      ser = try do
        data |> xpath(
          ~x"//Data/Series"l,
          id: ~x"./seriesid/text()"i,
          name: ~x"./SeriesName/text()"s
        )
      catch
        :exit, e -> Logger.error("Error while parsing TVDB XML", [additional: e]); %{}
      end

      ser = ser |> Enum.find(fn(s) -> String.equivalent?(s[:name], show_name) end)

      ser && ser[:id] || nil
    end
  end
end
