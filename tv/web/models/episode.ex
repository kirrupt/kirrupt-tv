defmodule Model.Episode do
  require Logger
  use KirruptTv.Web, :model

  alias KirruptTv.Repo

  schema "episodes" do
    field :title, :string, default: ""
    field :season, :integer
    field :episode, :integer
    field :tvrage_url, :string
    field :airdate, Timex.Ecto.DateTime
    field :summary, :string
    field :screencap, :string


    timestamps(inserted_at: :added, updated_at: :last_updated)

    belongs_to :show, Model.Show
    many_to_many :users, Model.User, join_through: "watched_episodes"
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:show_id, :title, :season, :episode, :tvrage_url, :airdate, :summary, :screencap])
    |> validate_required([:show_id, :episode, :season])
  end

  def show_thumb(obj) do
    obj.show
    |> Model.Show.show_thumb
  end

  def mark_as_watched(episode_id, user) do
    if episode = Repo.get(Model.Episode, episode_id) do
      if Repo.get_by(Model.UserShow, %{show_id: episode.show_id, user_id: user.id}) do
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
      if Repo.get_by(Model.UserShow, %{show_id: episode.show_id, user_id: user.id}) do
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

  defp download_and_save_image(url) do
    KirruptTv.Helpers.FileHelpers.download_and_save_file(url, "#{KirruptTv.Helpers.FileHelpers.root_folder}/static", "shows")
  end

  defp get_picture_url_changes(episode, e_data, changes) do
    cond do
      # if picture is specified, check if the file actually exists
      episode.screencap && KirruptTv.Helpers.FileHelpers.file_exists(episode.screencap) ->
        changes
      # picture is not specified or doesn't exists, check if tvmaze has url to it
      e_data[:screencap] && String.contains?(e_data[:screencap], ["tvrage", "tvmaze"]) ->
        Map.merge(changes, %{screencap: download_and_save_image(e_data[:screencap])})
      # picture is specified but it doesn't exists, tvmaze doesn't have it
      episode.screencap ->
        Map.merge(changes, %{picture_url: nil})
      # picture is not specified and tvmaze doesn't have it
      true ->
        changes
    end
  end

  def insert_or_update(show, e_data) do
    episode =
      case Repo.get_by(Model.Episode, %{season: e_data[:season], episode: e_data[:episode], show_id: show.id}) do
        nil -> %Model.Episode{season: e_data[:season], episode: e_data[:episode], show_id: show.id}
        ep  -> ep
      end

    changes = %{
      title: e_data[:title] || "",
      tvrage_url: e_data[:url],
      airdate: Common.Timex.parse(e_data[:airdate], "{YYYY}-{0M}-{0D}"),
      summary: e_data[:summary]
    }

    changes = get_picture_url_changes(episode, e_data, changes)

    result = episode
    |> Model.Episode.changeset(changes)
    |> Repo.insert_or_update

    case result do
      {:ok, struct}        -> struct
      {:error, _changeset} -> Logger.error("Could't insert or update episode '#{e_data[:episode]}' for show id #{show.id}"); nil
    end
  end
end
