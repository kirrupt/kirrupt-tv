defmodule KirruptTv.EpisodeTest do
  use KirruptTv.ModelCase

  alias KirruptTv.Episode
  alias Model.Episode

  @valid_attrs %{show_id: 10, title: "lala", season: "1", episode: "2", tvrage_url: "some-url", airdate: Timex.now, summary: "test", screencap: "path"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Episode.changeset(%Episode{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Episode.changeset(%Episode{}, @invalid_attrs)
    refute changeset.valid?
  end
end
