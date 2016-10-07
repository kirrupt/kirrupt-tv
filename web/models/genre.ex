defmodule Model.Genre do
  use KirruptTv.Web, :model

  schema "genres" do
    field :name, :string
    field :url, :string

    many_to_many :shows, Model.Show, join_through: "shows_genres"

    #timestamps()
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
