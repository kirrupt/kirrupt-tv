defmodule KirruptTv.Helpers.BackgroundHelpers do

  def random_background(shows) do
    shows
    |> Enum.map(fn(s) -> s.fixed_background end)
    |> Enum.reject(fn(bg) -> bg == nil end)
    |> Enum.shuffle
    |> Enum.take(1)
    |> Enum.at(0)
  end
end
