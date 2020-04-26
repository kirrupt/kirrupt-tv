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
    auto_hash = cond do
      ah = Map.get(conn.req_cookies, "auto_hash") -> ah
      ah = conn.req_headers |> Enum.find(fn({header, _}) -> header == "authorization" end) ->
        {_header, token} = ah
        token |> String.split(" ") |> List.last
      true -> nil
    end

    if auto_hash do
      Repo.get_by(User, auto_hash: auto_hash)
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
    case conn.private[:pipeline_name] do
      :browser -> %{device_type: "browser", device_code: "/"}
      :api -> %{device_type: "api", device_code: "/"}
      name -> raise "invalid pipeline_name: #{name}"
    end
  end

  def fake_user(user_id \\ nil) do
    if user_id != nil do
      Repo.get(User, user_id)
    end
  end
end
