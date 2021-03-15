defmodule KirruptTv.Helpers.FileHelpers do
  require Logger

  def root_folder do
    Application.app_dir(:kirrupt_tv, "priv")
  end

  def download_file(url, dest_path) do
    if body = get_image(url) do
      case File.write(dest_path, body) do
        {:error, reason} -> Logger.error("Could not write file from #{url} -> File.write error :#{reason}"); nil
        _ -> dest_path
      end
    end
  end

  def file_exists(name, base_folder \\ "#{KirruptTv.Helpers.FileHelpers.root_folder}/static", dest_folder \\ nil) do
    image_path = case dest_folder do
      nil -> name
      _ -> Path.join(dest_folder, name)
    end

    File.exists?(Path.join(base_folder, image_path))
  end

  def mkdirs(folder_path) do
    if File.exists?(folder_path) do
      folder_path
    else
      case File.mkdir_p(folder_path) do
        {:error, reason} -> Logger.error("Could not create folders '#{folder_path}' -> File.mkdir_p error :#{reason}"); nil
        _ -> folder_path
      end
    end
  end

  def download_and_save_file(url, base_folder, dest_folder \\ nil)
  def download_and_save_file(nil, _, _), do: nil
  def download_and_save_file(_, nil, _), do: nil
  def download_and_save_file(url, base_folder, dest_folder) do
    image_name = "#{UUID.uuid4(:hex)}.#{url |> String.split(".") |> List.last}"

    mkdirs(case dest_folder do
      nil -> base_folder
      _ -> Path.join(base_folder, dest_folder)
    end)

    image_path = case dest_folder do
      nil -> image_name
      _ -> Path.join(dest_folder, image_name)
    end

    # return relative path if image is downloaded (download_file reuturns absolute path)
    case download_file(url, Path.join(base_folder, image_path)) do
      nil -> nil
      _ -> image_path
    end
  end

  defp get_image(url) do
    response = HTTPoison.get url

    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> body
      _ -> Logger.error("Could not access #{response} #{url}"); nil
    end
  end
end
