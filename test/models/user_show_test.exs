defmodule KirruptTv.UserShowTest do
  use KirruptTv.ModelCase

  alias KirruptTv.UserShow
  alias Model.UserShow

  @valid_attrs %{user_id: 10, show_id: 20, modified: Timex.now, ignored: false, date_added: Timex.now}
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
