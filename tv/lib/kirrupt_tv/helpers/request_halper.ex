defmodule KirruptTv.Helpers.RequestHelpers do
  def get_req_header(%Plug.Conn{req_headers: headers}, key) when is_binary(key) do
    for {k, v} <- headers, k == key, do: v
  end

  def xhr?(conn) do
   "XMLHttpRequest" in get_req_header(conn, "x-requested-with")
 end
end
