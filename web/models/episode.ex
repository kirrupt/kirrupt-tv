defmodule Model.Episode do
  use KirruptTv.Web, :model

  alias KirruptTv.Repo

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

  def mark_as_watched(episode_id, user) do
    if episode = Repo.get(Model.Episode, episode_id) do
      if us = Repo.get_by(Model.UserShow, %{show_id: episode.show_id, user_id: user.id}) do
        unless we = Repo.get_by(Model.WatchedEpisode, %{episode_id: episode.id, user_id: user.id}) do
          we = %Model.WatchedEpisode {
            user_id: user.id,
            episode_id: episode.id,
            added: Timex.now
          }
          case Repo.insert we do
            {:ok, _struct} ->
              mark_as_watched_status(episode, user, true)
              true
            {:error, _changeset} -> false
          end
        else
          true
        end
      end
    end
  end

  def mark_as_unwatched(episode_id, user) do
    if episode = Repo.get(Model.Episode, episode_id) do
      if us = Repo.get_by(Model.UserShow, %{show_id: episode.show_id, user_id: user.id}) do
        if we = Repo.get_by(Model.WatchedEpisode, %{episode_id: episode.id, user_id: user.id}) do
          case Repo.delete we do
            {:ok, _struct} ->
              mark_as_watched_status(episode, user, false)
              true
            {:error, _changeset} -> false
          end
        else
          true
        end
      end
    end
  end

  defp mark_as_watched_status(episode, user, status) do
    result =
      case Repo.get_by(Model.WatchedEpisodeStatus, %{episode_id: episode.id, user_id: user.id}) do
        nil  -> %Model.WatchedEpisodeStatus{episode_id: episode.id, user_id: user.id}
        wes -> wes
      end
      |> Model.WatchedEpisodeStatus.changeset(%{modified: Timex.now, status: status})
      |> Repo.insert_or_update

    case result do
      {:ok, _struct}       -> true
      {:error, _changeset} -> false
    end
  end
end
