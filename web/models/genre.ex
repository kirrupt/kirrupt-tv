defmodule Model.Genre do
  use KirruptTv.Web, :model

  import KirruptTv.Helpers.BackgroundHelpers

  alias KirruptTv.Repo

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

  def index(url) do
    g = Repo.get_by(Model.Genre, url: url)

    if g do
      shows = Repo.all(from show in Model.Show,
      join: sg in Model.ShowGenre, on: sg.show_id == show.id,
      where: sg.genre_id == ^g.id)

      %{
        genre: g,
        shows: shows,
        background: random_background(shows)
      }
    else
      nil
    end
  end
end
