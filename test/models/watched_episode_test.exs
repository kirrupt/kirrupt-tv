defmodule KirruptTv.WatchedEpisodeTest do
  use KirruptTv.ModelCase

  alias KirruptTv.WatchedEpisode
  alias Model.WatchedEpisode

  @valid_attrs %{}
  # @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = WatchedEpisode.changeset(%WatchedEpisode{}, @valid_attrs)
    assert changeset.valid?
  end

  """
  test "changeset with invalid attributes" do
    changeset = WatchedEpisode.changeset(%WatchedEpisode{}, @invalid_attrs)
    refute changeset.valid?
  end
  """
end
