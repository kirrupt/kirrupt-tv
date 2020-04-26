defmodule KirruptTv.PageControllerTest do
  use KirruptTv.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "TV Episodes"
  end
end
