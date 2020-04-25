defmodule KirruptTv.Common.TimexTest do
    use KirruptTv.ModelCase

    test "valid date" do
        assert Common.Timex.parse("2020-01-01", "{YYYY}-{0M}-{0D}") == ~N[2020-01-01 00:00:00]
    end

    test "invalid date" do
        assert Common.Timex.parse("LALA-01-01", "{YYYY}-{0M}-{0D}") == nil
    end
  end
