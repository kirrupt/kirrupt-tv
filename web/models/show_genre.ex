defmodule Model.ShowGenre do
  use KirruptTv.Web, :model

  alias KirruptTv.Repo

  @primary_key false
  schema "shows_genres" do
    belongs_to :show, Model.Show, primary_key: true
    belongs_to :genre, Model.Genre, primary_key: true
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end

  def insert(show, genre) do
    result =
      case Repo.get_by(Model.ShowGenre, %{show_id: show.id, genre_id: genre.id}) do
        nil  -> %Model.ShowGenre{show_id: show.id, genre_id: genre.id}
        sg -> sg
      end
      |> Model.ShowGenre.changeset(%{})
      |> Repo.insert_or_update

    case result do
      {:ok, struct}        -> struct
      {:error, _changeset} -> nil
    end
  end
end
