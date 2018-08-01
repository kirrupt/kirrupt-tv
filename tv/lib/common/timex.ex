defmodule Common.Timex do
  require Logger

  def parse(date, format) do
    case Timex.parse(date, format) do
      {:ok, d} -> d
      {:error, err} -> Logger.warn("Could't parse date(#{date}) with format (#{format})"); nil
    end
  end
end
