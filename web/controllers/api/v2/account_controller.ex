defmodule KirruptTv.Api.V2.AccountController do
  use KirruptTv.Web, :controller

  plug(KirruptTv.Plugs.Authenticate)
  plug(KirruptTv.Plugs.Authenticated when action in [:user_info])

  def login(conn, params) do
    cond do
      is_nil(params["username"]) || is_nil(params["password"]) ->
        conn
        |> put_status(400)
        |> render("login.json", data: %{error: "MISSING_USERNAME_OR_PASSWORD"})

      user = Model.User.authenticate(params["username"], params["password"]) ->
        render(conn, "login.json", data: %{token: user.auto_hash})

      true ->
        conn
        |> put_status(400)
        |> render("login.json", data: %{error: "INVALID_USERNAME_OR_PASSWORD"})
    end
  end

  def user_info(conn, _params) do
    render(conn, "user-info.json", data: %{user: conn.assigns[:current_user]})
  end
end
