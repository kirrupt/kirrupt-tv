defmodule KirruptTv.UserDeviceVisitTest do
  use KirruptTv.ModelCase

  alias KirruptTv.UserDeviceVisit
  alias Model.UserDeviceVisit

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserDeviceVisit.changeset(%UserDeviceVisit{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserDeviceVisit.changeset(%UserDeviceVisit{}, @invalid_attrs)
    refute changeset.valid?
  end
end
