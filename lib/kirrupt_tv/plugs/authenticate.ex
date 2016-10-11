defmodule KirruptTv.Plugs.Authenticate do
  import Plug.Conn
  alias KirruptTv.Repo
  alias Model.User

  def init(options) do
    options
  end

  def call(conn, _) do
    conn = fetch_session(conn)
    assign(conn, :current_user, fake_user(7))
  end

  def fake_user(user_id \\ nil) do
    if user_id != nil do
      Repo.get(User, user_id)
    end
  end
end
