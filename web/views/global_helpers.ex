defmodule KirruptTv.GlobalHelpers do
  use Phoenix.HTML

  def leading_zero(num) do
    if num < 10 do
      "0#{num}"
    else
      num
    end
  end

  def get_show_url(show) do
    show.url || show.id
  end
end
