defmodule KirruptTv.ThumbController do
  use KirruptTv.Web, :controller

  def index(conn, %{"thumb_type" => thumb_type, "image_path" => image_path}) do
    {img_name, img_path} = image_path(thumb_type, image_path |> Enum.join("/"))

    if img_path do
      conn
      |> put_resp_content_type(MIME.from_path(img_path))
      |> put_resp_header("content-disposition", "attachment; filename=#{img_name}")
      |> send_file(200, img_path)
    else
      conn
      |> send_resp(404, "404 Not Found")
    end
  end

  defp image_path(thumb_type, image_path) do
    img_path = KirruptTv.Helpers.ThumbHelper.get_thumb(thumb_type, image_path)

    {Path.basename(image_path), img_path}
  end
end
