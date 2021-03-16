defmodule KirruptTv.Helpers.RequestHelpers do
  import Phoenix.Controller

  def get_req_header(%Plug.Conn{req_headers: headers}, key) when is_binary(key) do
    for {k, v} <- headers, k == key, do: v
  end

  def xhr?(conn) do
    "XMLHttpRequest" in get_req_header(conn, "x-requested-with")
  end

  def disable_layout_on_xhr(conn) do
    case xhr?(conn) do
      true -> conn |> put_layout(false)
      false -> conn
    end
  end
end
