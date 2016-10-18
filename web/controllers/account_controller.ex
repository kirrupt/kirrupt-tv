defmodule KirruptTv.AccountController do
  use KirruptTv.Web, :controller
  use Timex

  plug KirruptTv.Plugs.Authenticate
  plug KirruptTv.Plugs.Authenticated when action in [:logout]
  plug KirruptTv.Plugs.Authenticated.Redirect when action in [:login]

  plug :put_layout, "account.html"

  alias Model.User

  def login(conn, params) do
    if params["login"] && (user = Model.User.authenticate(params["login"]["username"], params["login"]["password"])) do
      conn
      |> put_session(:current_user, user.id)
      |> put_flash(:info, "Logged in")
      |> redirect(to: KirruptTv.Router.Helpers.recent_path(conn, :index))
    else
      conn
      |> login_flash
      |> render("login.html", %{title: "Login"})
    end
  end

  defp login_flash(conn) do
    cond do
      conn.method == "GET" -> conn
      true -> put_flash(conn, :info, "Wrong username or password")
    end
  end

  def logout(conn, _) do
    conn
    |> delete_session(:current_user)
    |> put_flash(:info, "Logged out")
    |> redirect(to: "/")
  end
end
