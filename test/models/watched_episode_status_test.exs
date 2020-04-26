defmodule KirruptTv.WatchedEpisodeStatusTest do
  use KirruptTv.ModelCase

  alias KirruptTv.WatchedEpisodeStatus
  alias Model.WatchedEpisodeStatus

  @valid_attrs %{user_id: 10, episode_id: 20, modified: Timex.now, status: true}
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
