defmodule Model.ShowGenre do
  use KirruptTv.Web, :model

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
end
