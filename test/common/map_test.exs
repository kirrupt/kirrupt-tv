defmodule KirruptTv.Common.MapTest do
  use KirruptTv.ModelCase

  test "compact" do
    data = %{
      a: "a",
      b: nil,
      c: "c"
    }

    assert data |> Common.Map.compact() == %{a: "a", c: "c"}
  end

  test "compact_selective" do
    data = %{
      a: "a",
      b: nil,
      c: "c",
      d: nil
    }

    assert data |> Common.Map.compact_selective([:d]) == %{a: "a", b: nil, c: "c"}
  end
end
