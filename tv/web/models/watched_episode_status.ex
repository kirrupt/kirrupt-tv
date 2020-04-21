defmodule Model.WatchedEpisodeStatus do
  use KirruptTv.Web, :model

  @primary_key false
  schema "watched_episodes_status" do
    field :modified, :utc_datetime
    field :status, :boolean

    belongs_to :user, Model.User, primary_key: true
    belongs_to :episode, Model.Episode, primary_key: true
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :episode_id, :modified, :status])
    |> validate_required([:user_id, :episode_id, :modified, :status])
  end
end
