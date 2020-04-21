defmodule Model.Show do
  require Logger
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
    field :last_checked, :utc_datetime
    field :wikipedia_url, :string
    field :picture_url, :string
    field :thumbnail_url, :string
    field :wikipedia_checked, :boolean
    field :tvrage_id, :integer
    field :tvmaze_id, :integer
    field :year, :integer
    field :started, :date
    field :ended, :date
    field :origin_country, :string
    field :airtime, :string
    field :airday, :string
    field :timezone, :string
    field :summary, :string
    field :thetvdb_id, :string
    field :fixed_thumb, :string
    field :fixed_background, :string
    field :fixed_banner, :string
    field :url, :string

    timestamps(inserted_at: :added, updated_at: :last_updated)

    has_many :episodes, Model.Episode

    many_to_many :users, Model.User, join_through: "users_shows"
    many_to_many :genres, Model.Genre, join_through: "shows_genres"
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:id, :name, :tvrage_url, :runtime, :genre, :status, :last_checked,
                     :wikipedia_url, :picture_url, :thumbnail_url, :wikipedia_checked,
                     :tvrage_id, :tvmaze_id, :year, :started, :summary, :thetvdb_id,
                     :fixed_thumb, :fixed_background, :fixed_banner, :url, :added])
    |> validate_required([:id, :name, :runtime, :status, :added])
  end

  def runtime_num(show) do
    case show.runtime do
      nil -> 0
      _ -> show.runtime
    end
  end

  def find_by_id(id) do
    Repo.get(Model.Show, id)
  end

  def find_by_url_or_id(id_or_url) do
    Repo.get_by(Model.Show, url: id_or_url) || find_by_id(id_or_url)
  end

  def show_thumb(show) do
    cond do
      show.fixed_thumb -> "/#{show.fixed_thumb}"
      show.picture_url -> "/#{show.picture_url}"
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

  def get_shows(ids) do
    Repo.all(
      from s in Model.Show,
      where: s.id in ^ids)
    |> Repo.preload([:genres])
  end

  def get_show_episodes(ids) do
    Repo.all(
      from e in Model.Episode,
      where: e.show_id in ^ids)
  end

  def get_show_updated_dates(ids) do
    Repo.all(
      from s in Model.Show,
      where: s.id in ^ids,
      select: [s.id, s.last_updated])
  end

  def get_show_episodes_updated_dates(ids) do
    Repo.all(
      from e in Model.Episode,
      where: e.show_id in ^ids,
      select: [e.id, e.show_id, e.last_updated])
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
    ) |> Repo.preload([:genres])
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

  defp download_and_save_image(url) do
    KirruptTv.Helpers.FileHelpers.download_and_save_file(url, "#{KirruptTv.Helpers.FileHelpers.root_folder}/static", "shows")
  end

  def add_tvmaze_show(tvmaze_id) do
    if s_obj = Repo.get_by(Model.Show, tvmaze_id: tvmaze_id) do
      s_obj
    else
      if info = KirruptTv.Parser.TVMaze.show_info(tvmaze_id) do
        s_obj = %Model.Show {
          name: info[:name],
          tvrage_url: info[:url],
          status: info[:status],
          tvmaze_id: info[:tvmaze_id],
          runtime: info[:runtime],
          genre: "",
          picture_url: info[:image],
          wikipedia_checked: false,
          picture_url: download_and_save_image(info[:image]),
          last_checked: Timex.now
        }

        case Repo.insert s_obj do
          {:ok, s_struct} -> update_show_and_episodes(s_struct); s_struct
          {:error, _changeset} -> nil
        end
      end
    end
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

  defp get_picture_url_changes(s_obj, info, changes) do
    cond do
      # if picture is specified, check if the file actually exists
      s_obj.picture_url && KirruptTv.Helpers.FileHelpers.file_exists(s_obj.picture_url) ->
        changes
      # picture is not specified or doesn't exists, check if tvmaze has url to it
      info[:image] ->
        Map.merge(changes, %{picture_url: download_and_save_image(info[:image])})
      # picture is specified but it doesn't exists, tvmaze doesn't have it
      s_obj.picture_url ->
        Map.merge(changes, %{picture_url: nil})
      # picture is not specified and tvmaze doesn't have it
      true ->
        changes
    end
  end

  def update_show_and_episodes(s_obj) do
    if info = KirruptTv.Parser.TVMaze.show_info(s_obj.tvmaze_id) do
      s_obj = s_obj |> Repo.preload([:genres])

      changes = %{
        last_checked: Timex.now,
        summary: info[:summary],
        status: info[:status],
        year: info[:year],
        started: info[:started],
        runtime: info[:runtime],
        origin_country: info[:origin_country],
        airtime: info[:airtime],
        airday: info[:airday],
        timezone: info[:timezone],
        thetvdb_id: get_the_tv_db_id(s_obj)
      }
      |> Common.Map.compact_selective([:summary])

      changes = get_picture_url_changes(s_obj, info, changes)

      # TODO
      # Remove old genres !!???
      info[:genres]
      |> Enum.each(fn(genre) ->
        if !Enum.find(s_obj.genres, fn(s_genre) -> String.downcase(s_genre.name) == String.downcase(genre) end) do
          if g_obj = Model.Genre.find_or_create(genre) do
            Model.ShowGenre.insert(s_obj, g_obj)
          end
        end
      end)

      result = s_obj
      |> Model.Show.changeset(changes)
      |> Repo.update

      case result do
        {:ok, struct}        -> s_obj = struct
        {:error, changeset} -> Logger.error("Could't update show '#{s_obj.id}' - #{inspect(changeset.errors)}"); fake_update(s_obj); false
      end

      if info[:episodes] do
        info[:episodes]
        |> Enum.each(fn(episode) -> Model.Episode.insert_or_update(s_obj, episode) end)
      end

      set_frant_tv_image(s_obj)
      set_url(s_obj)
    else
      Logger.error("Could't update show '#{s_obj.id}'"); fake_update(s_obj); nil
    end
  end

  defp fake_update(show) do
    Logger.warn("Fake updating #{show.id} due to failed updated.")

    show
    # update last_checked field
    |> Model.Show.changeset(%{last_checked: Timex.now})
    # force valid? flag, since validation might when updating
    |> Map.put(:valid?, true)
    # update show including last_updated field (=mimics behaviour of Python codebase)
    |> Repo.update
    |> case do
      {:ok, struct}        -> true
      {:error, changeset} -> Logger.error("Couldn't fake update show '#{show.id}' - #{inspect(changeset.errors)}"); false
    end
  end

  defp get_fanart_image_changes(changes, s_obj, images, attr, fanart_attr) do
    cond do
      # if picture is specified, check if the file actually exists
      Map.get(s_obj, attr) && KirruptTv.Helpers.FileHelpers.file_exists(s_obj.fixed_thumb) ->
        changes
      # picture is not specified or doesn't exists, check if fanart has url to it
      Map.get(images, fanart_attr) ->
        Map.put(changes, attr, (url = download_and_save_image(Map.get(images, fanart_attr) |> List.first)))
      # picture is specified but it doesn't exists, fanart doesn't have it
      Map.get(s_obj, attr) ->
        Map.put(changes, attr, nil)
      # picture is not specified and fanart doesn't have it
      true ->
        changes
    end
  end

  def set_frant_tv_image(s_obj) do
    cond do
      images = KirruptTv.Parser.FanartTV.get_image_list(s_obj.thetvdb_id) ->
        changes = %{}

        changes = get_fanart_image_changes(changes, s_obj, images, :fixed_thumb, :tvthumb)
        changes = get_fanart_image_changes(changes, s_obj, images, :fixed_background, :showbackground)
        changes = get_fanart_image_changes(changes, s_obj, images, :fixed_banner, :tvbanner)

        result = s_obj
        |> Model.Show.changeset(changes)
        |> Repo.update

        case result do
          {:ok, struct}        -> struct
          {:error, _changeset} -> Logger.error("Could't update show images '#{s_obj.id}'"); s_obj
        end
      true -> s_obj
    end
  end

  def set_url(s_obj) do
    case s_obj.url do
      nil ->
        result = s_obj
        |> Model.Show.changeset(%{url: init_url(s_obj)})
        |> Repo.update

        case result do
          {:ok, struct}        -> struct
          {:error, _changeset} -> Logger.error("Could't update show url '#{s_obj.id}'"); s_obj
        end
      _   -> s_obj
    end
  end

  def update_any_show do
    case Repo.one(
      from s in Model.Show,
      where: not is_nil(s.tvmaze_id),
      order_by: [asc: s.last_checked],
      limit: 1) do
        nil -> nil
        show ->
          IO.puts "Updating show #{show.id} (last checked: #{show.last_checked})..."
          Model.Show.update_show_and_episodes(show)
          show.id
      end
  end

  defp init_url(s_obj, counter \\ nil) do
    url = Common.URI.slugify(s_obj.name, counter)
    case Repo.get_by(Model.Show, url: url) do
      nil -> url
      _   -> init_url(s_obj, counter && counter + 1 || 1)
    end
  end

  defp get_the_tv_db_id(show) do
    cond do
      show.thetvdb_id -> show.thetvdb_id
      true ->
        id = KirruptTv.Parser.TheTVDB.get_show_id(show.name)
        case id != nil do
          true -> Integer.to_string(id)
          false -> id
        end
    end
  end
end
