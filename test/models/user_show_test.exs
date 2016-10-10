defmodule KirruptTv.UserShowTest do
  use KirruptTv.ModelCase

  alias KirruptTv.UserShow

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserShow.changeset(%UserShow{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserShow.changeset(%UserShow{}, @invalid_attrs)
    refute changeset.valid?
  end
end
