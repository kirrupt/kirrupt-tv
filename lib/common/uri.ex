defmodule Common.URI do
  require Logger

  defp slugify_append(str, nil), do: str
  defp slugify_append(str, counter) when is_integer(counter), do: "#{str}-#{counter}"

  defp slugify_append(str, counter) do
    Logger.warn("Slugify weren't provided with integer counter('#{counter}') for url('#{str}')")
    "#{str}-#{counter}"
  end

  def slugify(str, append \\ nil) do
    str
    |> String.normalize(:nfd)
    |> String.replace(~r/[^A-z\s]/u, "")
    |> String.replace(~r/\s/, "-")
    |> String.trim("-")
    |> String.downcase()
    |> slugify_append(append)
  end
end
