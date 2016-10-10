defmodule Model.Show do
  use KirruptTv.Web, :model
  use Timex

  alias KirruptTv.Repo
  alias Model.Episode
  alias Model.UserShow
  alias Model.WatchedEpisode

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

    many_to_many :users, Model.User, join_through: "users_shows"
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

  def find_by_url_or_id(id_or_url) do
    obj = Repo.get_by(Model.Show, url: id_or_url)
    if !obj && is_integer(id_or_url) do
      obj = Repo.get(Model.Show, id_or_url)
    end
    obj
  end

  def show_thumb(show) do
    cond do
      show.fixed_thumb -> "http://kirrupt.com/tv/static/#{show.fixed_thumb}"
      show.picture_url -> "http://kirrupt.com/tv/static/#{show.picture_url}"
      true -> nil
    end
  end

  def seasons(show_obj) do
    Repo.all(
      from e in Episode,
      where: e.show_id == ^show_obj.id,
      group_by: e.season,
      select: e.season
    )
  end

  def next_episode(show_obj) do
    Repo.all(
      from e in Episode,
      where: e.show_id == ^show_obj.id and e.airdate >= ^Timex.today and fragment("?", e.airdate) != ^"2013-00-00 00:00:00",
      order_by: [asc: e.season],
      order_by: [asc: e.episode],
      limit: 1
    ) |> List.first
  end

  def show(id_or_url, user \\ nil, season \\ nil) do
    s = find_by_url_or_id(id_or_url)
    |> Repo.preload([:genres])

    if s do
      ignored = false
      show_added = false
      next_episode = nil

      if user do
        show_user_connection = UserShow.connection(user, s)

        if show_user_connection do
          ignored = show_user_connection.ignored
          show_added = true
        end
      end

      latest_episodes = show_episodes(s, season)

      if season && Enum.count(latest_episodes) == 0 do
        nil
      else
        %{
          show: s,
          latest_episodes: latest_episodes,
          ignored: ignored,
          show_added: show_added,
          season: season,
          next_episode: next_episode(s),
          watched_episodes: watched_episodes(s, user)
        }
      end
    else
      nil
    end
  end

  defp watched_episodes(_show_obj, nil), do: []
  defp watched_episodes(show_obj, user) do
    Repo.all(
      from e in Episode,
      join: w in Model.WatchedEpisode, on: w.episode_id == e.id and w.user_id == ^user.id,
      where: e.show_id == ^show_obj.id,
      select: e.id
    )
  end

  defp season_query(query, nil), do: query
  defp season_query(query, season), do: where(query, [e], e.season == ^season)
  defp show_episodes_limit_query(query, nil), do: limit(query, 10)
  defp show_episodes_limit_query(query, _season), do: query

  defp show_episodes(show_obj, season) do
    Repo.all(
      from(e in Episode)
      |> where([e, s], e.airdate < ^Timex.today and fragment("?", e.airdate) != ^"2013-00-00 00:00:00" and e.show_id == ^show_obj.id)
      |> season_query(season)
      |> order_by([e], [desc: e.season])
      |> order_by([e], [desc: e.episode])
      |> show_episodes_limit_query(season)
    )|> Repo.preload([:show])
  end
end
