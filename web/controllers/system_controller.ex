defmodule KirruptTv.SystemController do
  use KirruptTv.Web, :controller

  alias Model.SearchShow

  def update_all(_conn, _params) do
    SearchShow.update_all()
  end
end
