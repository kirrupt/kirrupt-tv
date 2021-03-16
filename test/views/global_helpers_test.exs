defmodule KirruptTv.GlobalHelpersTest do
  use KirruptTv.ConnCase, async: true
  alias KirruptTv.GlobalHelpers

  test "unwrap error with message" do
    assert GlobalHelpers.unwrap_error({"lala", ""}) == "lala"
  end

  test "unwrap error without message" do
    assert GlobalHelpers.unwrap_error(nil) == nil
  end
end
