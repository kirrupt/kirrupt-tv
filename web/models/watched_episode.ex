defmodule Model.WatchedEpisode do
  use KirruptTv.Web, :model

  @primary_key false
  schema "watched_episodes" do
    field(:added, Timex.Ecto.DateTime)

    belongs_to(:user, Model.User, primary_key: true)
    belongs_to(:episode, Model.Episode, primary_key: true)
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
