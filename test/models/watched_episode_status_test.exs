defmodule KirruptTv.WatchedEpisodeStatusTest do
  use KirruptTv.ModelCase

  alias KirruptTv.WatchedEpisodeStatus

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = WatchedEpisodeStatus.changeset(%WatchedEpisodeStatus{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = WatchedEpisodeStatus.changeset(%WatchedEpisodeStatus{}, @invalid_attrs)
    refute changeset.valid?
  end
end
