defmodule Model.Genre do
  require Logger
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
    |> cast(params, [:name, :url])
    |> validate_required([:name])
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

  def find_or_create(genre_name) do
    case Repo.get_by(Model.Genre, name: String.downcase(genre_name)) do
      nil   ->
        case Repo.insert %Model.Genre {name: genre_name} do
          {:ok, g_struct} -> set_url(g_struct)
          {:error, _changeset} -> nil
        end
      g_obj -> set_url(g_obj)
    end
  end

  def set_url(g_obj) do
    case g_obj.url do
      nil ->
        result = g_obj
        |> Model.Genre.changeset(%{url: init_url(g_obj)})
        |> Repo.update

        case result do
          {:ok, struct}        -> struct
          {:error, _changeset} -> Logger.error("Could't update genre url '#{g_obj.id}'"); g_obj
        end
      _   -> g_obj
    end
  end

  defp init_url(g_obj, counter \\ nil) do
    url = Common.URI.slugify(g_obj.name, counter)
    case Repo.get_by(Model.Genre, url: url) do
      nil -> url
      _   -> init_url(g_obj, counter && counter + 1 || 1)
    end
  end
end
