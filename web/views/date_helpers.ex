defmodule KirruptTv.DateHelpers do
  use Phoenix.HTML
  use Timex

  def time_delta(date, days) do
    Timex.shift(date, days: days)
  end

  def format(date, format) do
    {_status, formated_date} = date |> Timex.format(format)
    formated_date
  end

  def format_date(value, format \\ "medium")
  def format_date("", _format), do: ""
  def format_date(value, format) do
    value = time_delta(value, 1)
    date = value |> Timex.to_date
    today = Timex.today
    tomorrow = time_delta(today, 1)
    yesterday = time_delta(today, -1)

    diff = Timex.diff(value, today, :days) |> abs

    cond do
      date == today -> "today"
      date == tomorrow -> "tomorrow"
      date == yesterday -> "yesterday"
      diff > 0 && diff < 8 -> value |> format("{WDfull}") |> String.downcase
      format == "diff" -> "#{diff} days"
      format == "full" -> value |> format("{WDfull}, {0D}. {Mfull}. {YYYY}")
      format == "medium" -> value |> format("{0D}.{0M}.{YYYY}")
    end
  end

  def datediff(value) do
    format_date(value, "diff")
  end
end
