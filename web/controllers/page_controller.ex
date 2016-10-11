defmodule KirruptTv.PageController do
  use KirruptTv.Web, :controller

  plug KirruptTv.Plugs.Authenticate

  # alias KirruptTv.Show

  def search(_conn, _params) do

  end
end
