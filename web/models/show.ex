defmodule Model.Show do
  use KirruptTv.Web, :model

  schema "shows" do
    field :name, :string
    field :tvrage_url, :string
    field :runtime, :integer
    field :genre, :string
    field :status, :string
    field :added, Timex.Ecto.DateTime
    field :last_checked, Timex.Ecto.DateTime
    field :last_updated, Timex.Ecto.DateTime
    field :wikipedia_url, :string
    field :picture_url, :string
    field :thumbnail_url, :string
    field :wikipedia_checked, :integer
    field :tvrage_id, :integer
    field :tvmaze_id, :integer
    field :year, :integer
    field :started, Timex.Ecto.Date
    field :ended, Timex.Ecto.Date
    field :origin_country, :string
    field :airtime, :string
    field :airday, :string
    field :timezone, :string
    field :summary, :string
    field :thetvdb_id, :integer
    field :fixed_thumb, :string
    field :fixed_background, :string
    field :fixed_banner, :string
    field :url, :string

    # timestamps()
    has_many :episodes, Model.Episode
    many_to_many :genres, Model.Genre, join_through: "shows_genres"
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:id, :name, :tvrage_url, :runtime, :genre, :status, :added])
    |> validate_required([:id, :name, :tvrage_url, :runtime, :genre, :status, :added])
  end

  def show_thumb(show) do
    cond do
      show.fixed_thumb -> "http://kirrupt.com/tv/static/#{show.fixed_thumb}"
      show.picture_url -> "http://kirrupt.com/tv/static/#{show.picture_url}"
      true -> nil
    end
  end
end
