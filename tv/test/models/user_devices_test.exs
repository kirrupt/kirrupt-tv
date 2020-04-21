defmodule KirruptTv.UserDevicesTest do
  use KirruptTv.ModelCase

  alias KirruptTv.UserDevices
  alias Model.UserDevices

  @valid_attrs %{device_type: "lala", device_code: "lala"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserDevices.changeset(%UserDevices{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserDevices.changeset(%UserDevices{}, @invalid_attrs)
    refute changeset.valid?
  end
end
