defmodule Common.Map do
  def compact(data) when is_map(data) do
    data
    |> Enum.reject(fn({_, v}) -> v == nil end)
    |> Enum.into(%{})
  end

  def compact_selective(data, nilable_fields) when is_map(data) do
    data
    |> Enum.reject(fn({_, v}) -> v == nil && Enum.member?(nilable_fields, v) end)
    |> Enum.into(%{})
  end
end
