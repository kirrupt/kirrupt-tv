defmodule KirruptTv.AccountController do
  use KirruptTv.Web, :controller
  use Timex

  plug KirruptTv.Plugs.Authenticate
  plug KirruptTv.Plugs.Authenticated when action in [:logout]
  plug KirruptTv.Plugs.Authenticated.Redirect when action in [:login]

  def login(conn, params) do
    user = if params["login"] do
      Model.User.authenticate(params["login"]["username"], params["login"]["password"])
    else
      nil
    end

    if user do
      opts = case params["login"]["auto_login"] == "true" do
        true  -> [max_age: 60 * 60 * 24 * 365]
        false -> []
      end

      conn
      |> put_resp_cookie("auto_hash", Model.User.get_auth_hash(user), opts)
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

  def register_new(conn, _params) do
    changeset = Model.User.registration_changeset(%Model.User{})

    conn
    |> render("register.html", %{title: "Register", changeset: changeset})
  end

  def register_create(conn, params) do
    changeset = Model.User.registration_changeset(%Model.User{}, params["user"])

    user = if changeset.valid? do
      Model.User.register_user(changeset)
    else
      nil
    end

    if user do
      conn
      |> put_resp_cookie("auto_hash", Model.User.get_auth_hash(user))
      |> put_flash(:info, "Successfully registered and logged in")
      |> redirect(to: recent_path(conn, :index))
    else
      changeset = %{changeset | action: :insert, errors: changeset.errors}
      render conn, "register.html", %{title: "Register", changeset: changeset}
    end
  end

  def logout(conn, _) do
    conn
    |> delete_resp_cookie("auto_hash")
    |> put_flash(:info, "Logged out")
    |> redirect(to: "/")
  end
end
