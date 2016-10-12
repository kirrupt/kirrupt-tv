defmodule KirruptTv.GlobalHelpers do
  use Phoenix.HTML

  def leading_zero(num) do
    cond do
      num < 10 -> "0#{num}"
      true -> num
    end
  end

  def limit_text(text) do
    cond do
      text |> String.length > 500 -> "#{String.slice(text, 0, 500)}..."
      true -> text
    end
  end

  def get_show_url(show) do
    show.url || show.id
  end
end
