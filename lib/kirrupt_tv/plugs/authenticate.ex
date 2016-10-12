defmodule KirruptTv.Plugs.Authenticate do
  import Plug.Conn
  alias KirruptTv.Repo
  alias Model.User

  def init(options) do
    options
  end

  def call(conn, _) do
    conn = fetch_session(conn)

    auto_hash = Map.get(conn.req_cookies, "auto_hash")
    if auto_hash != nil do
      user = Repo.get_by(User, auto_hash: auto_hash)
      if user != nil do
        assign(conn, :current_user, user)
      end
    end
  end

  def fake_user(user_id \\ nil) do
    if user_id != nil do
      Repo.get(User, user_id)
    end
  end
end
