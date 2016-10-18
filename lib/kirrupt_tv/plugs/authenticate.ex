defmodule KirruptTv.Plugs.Authenticate do
  import Plug.Conn
  alias KirruptTv.Repo
  alias Model.User

  def init(options) do
    options
  end

  def call(conn, _) do
    conn = fetch_session(conn)
    user = find_user(conn)
    check_device_visit(conn, user)
    assign(conn, :current_user, user)
  end

  defp find_user(conn) do
    cond do
      user_id = conn.private[:plug_session]["current_user"] ->
        Repo.get(User, user_id)
      auto_hash = Map.get(conn.req_cookies, "auto_hash") ->
        Repo.get_by(User, auto_hash: auto_hash)
      true -> nil
    end
  end

  defp check_device_visit(_conn, nil), do: nil
  defp check_device_visit(conn, user) do
    if device_info = device_type(conn) do
      if !Model.User.has_device(user, device_info[:device_type], device_info[:device_code]) do
        Model.User.add_device(user, device_info[:device_type])
      end
      Model.User.add_device_visit(user, device_info[:device_type], device_info[:device_code])
      Model.User.get_last_login(user, device_info[:device_type], device_info[:device_code])
    end
  end

  defp device_type(conn) do
    cond do
      Enum.member?(conn.private[:phoenix_pipelines], :browser) -> %{device_type: "browser", device_code: "/"}
      true -> nil
    end
  end

  def fake_user(user_id \\ nil) do
    if user_id != nil do
      Repo.get(User, user_id)
    end
  end
end
