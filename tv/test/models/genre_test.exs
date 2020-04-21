defmodule KirruptTv.GenreTest do
  use KirruptTv.ModelCase

  alias KirruptTv.Genre
  alias Model.Genre

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Genre.changeset(%Genre{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Genre.changeset(%Genre{}, @invalid_attrs)
    refute changeset.valid?
  end
end
