defmodule KirruptTv.ShowTest do
  use KirruptTv.ModelCase

  alias KirruptTv.Show

  @valid_attrs %{added: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, genre: "some content", id: 42, name: "some content", runtime: 42, status: "some content", tvrage_url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Show.changeset(%Show{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Show.changeset(%Show{}, @invalid_attrs)
    refute changeset.valid?
  end
end
