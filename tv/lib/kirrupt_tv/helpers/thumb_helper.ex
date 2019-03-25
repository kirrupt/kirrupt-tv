defmodule KirruptTv.Helpers.ThumbHelper do
  require Logger

  def static_folder do
    Application.app_dir(:kirrupt_tv, "priv/static")
  end

  def thumbs_folder, do: Path.join(static_folder(), "thumbs")
  def thumbs_folder(thumb_type, image_path), do: Path.dirname(thumb_image_path(thumb_type, image_path))

  def relative_thumb_folder(thumb_type, image_path) do
    thumbs_folder(thumb_type, image_path)
    |> String.slice(String.length(Application.app_dir(:kirrupt_tv)) + 1..-1)
  end

  def filename_from_path(path) do
    Path.basename(path)
  end

  def original_image_path(image_path) do
    Path.join(static_folder(), image_path)
  end

  def thumb_image_path(thumb_type, image_path) do
    Path.join([thumbs_folder(), thumb_type, image_path])
  end

  def get_thumb(_, nil), do: nil
  def get_thumb(nil, _), do: nil
  def get_thumb(thumb_type, image_path) do
    case File.exists?(original_image_path(image_path)) do
      true ->
        unless File.exists?(thumb_image_path(thumb_type, image_path)) do
          gen_thumb_image(thumb_type, image_path)
        end
        
        thumb_image_path(thumb_type, image_path)
      false -> nil
    end
  end

  defp gen_thumb_image(thumb_type, image_path) do
    case thumb_type do
      "cardthumb" -> KirruptTv.ApiCardThumb.store(original_image_path(image_path))
      "backgroundthumb" -> KirruptTv.ApiBackgroundThumb.store(original_image_path(image_path))
      _ -> nil
    end
  end
end
