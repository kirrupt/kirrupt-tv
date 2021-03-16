defmodule KirruptTv.ApiCardThumb do
  use Arc.Definition

  @versions [:thumb]

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  end

  # Define a thumbnail transformation:
  def transform(:thumb, _) do
    # FanArt tvposter original 1000 × 1426
    {:convert, "-thumbnail 260x160^ -gravity center -extent 260x160 -format jpg", :jpg}
  end

  # Override the storage directory:
  def storage_dir(_, {file, _}) do
    KirruptTv.Helpers.ThumbHelper.relative_thumb_folder(
      "cardthumb",
      Path.join("shows", file.file_name)
    )
  end
end
