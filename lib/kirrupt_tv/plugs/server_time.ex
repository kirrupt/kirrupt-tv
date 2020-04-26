defmodule KirruptTv.Plugs.ServerTime do
  use Plug.Builder

  plug Plug.Logger
  plug :set_server_time_to_header

  def set_server_time_to_header(conn, _) do
    merge_resp_headers(conn, [
      {"server-time", Timex.now |> DateTime.to_iso8601 }
    ])
  end
end
