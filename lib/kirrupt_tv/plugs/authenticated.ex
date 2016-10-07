defmodule KirruptTv.Plugs.Authenticated do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _) do
    conn = fetch_session(conn)
    assign(conn, :current_user, nil)
  end
end
