defmodule KirruptTv.Api.V2.RecommendationsController do
  use KirruptTv.Web, :controller

  plug KirruptTv.Plugs.Authenticate

  def my(conn, _) do
    render conn,
           "recommendations.json",
           data: Model.Recommendations.user(conn.assigns[:current_user])
  end

  def show(conn, %{"id" => id}) do
    render conn, "recommendations.json", data: Model.Recommendations.show(id)
  end
end
