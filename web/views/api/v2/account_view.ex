defmodule KirruptTv.Api.V2.AccountView do
  use KirruptTv.Web, :view

  def render("login.json", %{data: data}) do
    data
  end

  def render("user-info.json", %{data: %{user: user}}) do
    %{
      id: user.id,
      username: user.username,
      first_name: user.first_name,
      last_name: user.last_name,
      date_joined: user.date_joined |> DateTime.to_iso8601(),
      email: user.email
    }
  end
end
