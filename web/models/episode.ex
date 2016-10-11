defmodule Model.Episode do
  use KirruptTv.Web, :model

  schema "episodes" do
    field :title, :string
    field :season, :integer
    field :episode, :string
    field :tvrage_url, :string
    field :airdate, Timex.Ecto.DateTime
    field :added, Timex.Ecto.DateTime
    field :summary, :string
    field :screencap, :string
    field :last_updated, Timex.Ecto.DateTime

    belongs_to :show, Model.Show
    many_to_many :users, Model.User, join_through: "watched_episodes"
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end

  def show_thumb(obj) do
    obj.show
    |> Model.Show.show_thumb
  end
end
