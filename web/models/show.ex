defmodule Model.Show do
  use KirruptTv.Web, :model
  use Timex

  alias KirruptTv.Repo
  alias Model.Episode
  alias Model.UserShow

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

  def runtime_num(show) do
    case show.runtime do
      nil -> 0
      _ -> show.runtime
    end
  end

  def find_by_id(id) when is_integer(id), do: Repo.get(Model.Show, id)
  def find_by_id(_), do: nil

  def find_by_url_or_id(id_or_url) do
    Repo.get_by(Model.Show, url: id_or_url) || find_by_id(id_or_url)
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
    if s = find_by_url_or_id(id_or_url) do
      s = Repo.preload(s, [:genres])
      show_user_connection = if user, do: UserShow.connection(user, s)
      latest_episodes = show_episodes(s, season)

      unless season && Enum.count(latest_episodes) == 0 do
        %{
          show: s,
          latest_episodes: latest_episodes,
          ignored: if show_user_connection do show_user_connection.ignored else false end,
          show_added: show_user_connection != nil,
          season: season,
          next_episode: next_episode(s),
          watched_episodes: watched_episodes(s, user)
        }
      end
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

  def show_list(id_or_url, user \\ nil) do
    if s = find_by_url_or_id(id_or_url) do
      s = Repo.preload(s, [:episodes]) |> Repo.preload([:genres])
      show_user_connection = if user, do: UserShow.connection(user, s)

      %{
        show: s,
        ignored: if show_user_connection do show_user_connection.ignored else false end,
        show_added: show_user_connection != nil,
        by_seasons: Enum.group_by(s.episodes, fn(x) -> x.season end),
        watched_episodes: watched_episodes(s, user)
      }
    end
  end

  def ignore_show(show, user) do
    if us = Repo.get_by(Model.UserShow, %{show_id: show.id, user_id: user.id}) do
      result = us
      |> Model.UserShow.changeset(%{modified: Timex.now, ignored: !us.ignored})
      |> Repo.insert_or_update

      case result do
        {:ok, _struct}       -> true
        {:error, _changeset} -> false
      end
    end
  end

  def find_shows_on_kirrupt(name) do
    Repo.all(
      from s in Model.Show,
      where: like(s.name, ^"%#{name}%"),
      order_by: s.name
    )
  end

  def find_shows_on_tvmaze(name) do
    tvmaze_shows = KirruptTv.Parser.TVMaze.search(name)

    ids = tvmaze_shows |> Enum.map(fn(x) -> x[:tvmaze_id] end)

    our_show_tvmaze_ids = Repo.all(
      from s in Model.Show,
      where: s.tvmaze_id in ^ids,
      select: s.tvmaze_id
    )

    tvmaze_shows
    |> Enum.reject(fn(x) -> Enum.member?(our_show_tvmaze_ids, x[:tvmaze_id]) end)
  end

  def filter_user_shows(_shows, nil), do: []
  def filter_user_shows(shows, user) do
    us = Repo.all(
      from us in Model.UserShow,
      where: us.show_id in ^Enum.map(shows, fn(x) -> x.id end) and us.user_id == ^user.id,
      select: us.show_id)
    shows |> Enum.reject(fn(x) -> !Enum.member?(us, x.id) end)
  end

  def search(q, user) do
    user_id = user && user.id || 0

    Repo.all(
      from s in Model.Show,
      left_join: us in Model.UserShow, on: us.show_id == s.id and us.user_id == ^user_id,
      where: fragment("MATCH(?) AGAINST (? IN BOOLEAN MODE)", s.name, ^"*#{q}*"),
      order_by: [desc: us.user_id],
      order_by: [asc: us.ignored],
      limit: 30)
  end
end
