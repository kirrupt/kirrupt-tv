defmodule KirruptTv.GlobalHelpers do
  use Phoenix.HTML

  def img_prefix(nil), do: nil

  def img_prefix(url) do
    url
  end

  def thumb(nil, _), do: nil
  def thumb(_, nil), do: nil

  def thumb(url, thumb_type) do
      case validate_thumb_type(thumb_type) do
        true ->
          "#{KirruptTv.Endpoint.url()}/thumbs/#{thumb_type}#{
            KirruptTv.Endpoint.static_path("/#{url}")
          }"

        false ->
          img_prefix(url)
      end
  end

  def leading_zero(num) do
    cond do
      num < 10 -> "0#{num}"
      true -> num
    end
  end

  def limit_text(text) do
    cond do
      text |> String.length() > 500 -> "#{String.slice(text, 0, 500)}..."
      true -> text
    end
  end

  def get_show_url(show) do
    show.url || show.id
  end

  defp validate_thumb_type(type) do
    Enum.member?(["backgroundthumb", "cardthumb"], type)
  end

  def unwrap_error(nil), do: nil
  def unwrap_error({msg, _}), do: msg
end
