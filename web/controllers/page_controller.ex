defmodule KirruptTv.PageController do
  use KirruptTv.Web, :controller

  plug KirruptTv.Plugs.Authenticated

  alias KirruptTv.Show

  def search(conn, _params) do

  end
end
