defmodule Model.User do
  require Logger
  use KirruptTv.Web, :model
  use Timex

  import KirruptTv.DateHelpers
  import KirruptTv.Helpers.BackgroundHelpers

  alias KirruptTv.Repo
  alias Model.Episode
  alias Model.Genre
  alias Model.Show

  schema "users" do
    field :username, :string
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :password, :string
    field :password_new_hash, :string
    field :is_active, :boolean
    field :last_login, Timex.Ecto.DateTime, default: Timex.now
    field :date_joined, Timex.Ecto.DateTime, default: Timex.now
    field :auto_hash, :string
    field :registration_code, :string
    field :password_code, :string
    field :is_editor, :boolean, default: false
    field :is_developer, :boolean, default: false
    field :is_admin, :boolean, default: false
    field :skype_handle, :string
    field :google_id, :string
    field :google_session_id, :string

    many_to_many :shows, Model.Show, join_through: "users_shows"
    many_to_many :episodes, Model.Episode, join_through: "watched_episodes"
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:auto_hash])
    |> validate_required([])
  end

  def registration_changeset(model, params \\ %{}) do
    model
    |> cast(params, ~w(password first_name last_name username email), [])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6, message: "should be at least 6 characters")
    |> validate_confirmation(:password, message: "does not match password")
    |> unique_constraint(:username, name: :username)
    |> unique_constraint(:email, name: :email_index)
    |> put_password_hash
  end

  def register_user(changeset) do
    case Repo.insert(changeset) do
      {:ok, model} -> model
      {:error, _changeset} -> nil
    end
  end

  defp gen_sha1_password(password) do
    # TODO deprecate it
    salt = UUID.uuid4(:hex) |> String.slice(0, 10)
    new_pass = :crypto.hash(:sha, "#{salt}#{password}") |> Base.encode16 |> String.downcase
    "sha1$#{salt}$#{new_pass}"
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->

        changeset
        |> put_change(:password_new_hash, Comeonin.Bcrypt.hashpwsalt(pass))
        |> put_change(:password, gen_sha1_password(pass))
      _ ->
        changeset
    end
  end

  defp overview_limit_query(query, nil) do
    query
    |> limit(10)
  end
  defp overview_limit_query(query, _user), do: query

  defp overview_user_shows_query(query, nil), do: query
  defp overview_user_shows_query(query, user) do
    query
    |> join(:inner, [e], us in Model.UserShow, us.show_id == e.show_id and us.user_id == ^user.id and us.ignored == false)
  end

  defp overview_user_query(query, nil), do: query
  defp overview_user_query(query, user) do
    query
    |> overview_user_shows_query(user)
    |> join(:left, [e], we in Model.WatchedEpisode, we.episode_id == e.id and we.user_id == ^user.id)
    |> where([e, s, us, we], is_nil(we.added))
  end

  def overview(user \\ nil, search \\ "") do
    today = Timex.today
    fourteendays_ago = time_delta(today, -14)
    onemonthfromtoday = time_delta(today, 30)

    search = "%#{search}%"

    recent = Repo.all(
      from(e in Episode)
      |> join(:inner, [e], s in Model.Show, s.id == e.show_id)
      |> overview_user_query(user)
      |> where([e, s], e.airdate > ^fourteendays_ago and e.airdate < ^today and fragment("DAY(?)", e.airdate) != 0 and like(s.name, ^search))
      |> order_by([e], [desc: e.airdate])
      |> order_by([e, s], [asc: s.name])
      |> overview_limit_query(user))
    |> Repo.preload([:show])

    soon = Repo.all(
      from(e in Episode)
      |> join(:inner, [e], s in Model.Show, s.id == e.show_id)
      |> overview_user_query(user)
      |> where([e, s], e.airdate >= ^today and e.airdate < ^onemonthfromtoday and like(s.name, ^search))
      |> order_by([e], [asc: e.airdate])
      |> order_by([e, s], [asc: s.name])
      |> limit(10))
    |> Repo.preload([:show])

    countdown = Repo.all(
      from(e in Episode)
      |> join(:inner, [e], s in Model.Show, s.id == e.show_id)
      |> overview_user_shows_query(user)
      |> where([e, s], e.airdate >= ^today and like(s.name, ^search))
      # group_by: s.id,
      |> order_by([e], [asc: e.airdate])
      |> order_by([e, s], [asc: s.name])
      |> order_by([e], [desc: e.episode])
      |> limit(55))
    |> Repo.preload([:show])

    shows = Enum.map(recent, fn(e) -> e.show end)
      ++ Enum.map(soon, fn(e) -> e.show end)
      ++ Enum.map(countdown, fn(e) -> e.show end)

    %{
      recent: recent,
      soon: soon,
      countdown: countdown,
      genres: Genre |> Repo.all,
      background: random_background(shows)
    }
  end

  def time_wasted(user) do
    shows = Repo.all(
      from s in Model.Show,
      join: us in Model.UserShow, on: us.show_id == s.id and us.user_id == ^user.id,
      order_by: s.name
    )

    episodes = Repo.all(
      from e in Model.Episode,
      join: we in Model.WatchedEpisode, on: we.episode_id == e.id and we.user_id == ^user.id,
      group_by: e.show_id,
      select: [e.show_id, count(e.id)]
    )

    shows_s = shows |> Enum.map(fn(show) ->
      num_of_episodes = case episodes |> Enum.find(fn([x, _]) -> x == show.id end) do
        nil           -> 0
        show_episodes -> show_episodes |> List.last
      end

      %{
        id: show.id,
        name: show.name,
        runtime: show.runtime,
        url: show.url,
        status: show.status,
        episodes: num_of_episodes,
        time_wasted: Duration.invert(%Duration{megaseconds: 0, seconds: Show.runtime_num(show) * num_of_episodes * 60, microseconds: 0}) |> Timex.format_duration(:humanized)
      }
    end)

    time = shows_s |> Enum.reduce(0, fn(show, acc) -> acc + Show.runtime_num(show) * show.episodes end)

    %{
      shows: shows_s,
      time: Duration.invert(%Duration{megaseconds: 0, seconds: time * 60, microseconds: 0}) |> Timex.format_duration(:humanized),
      background: random_background(shows)
    }
  end

  def get_user_shows(user) do
      Repo.all(
        from s in Model.Show,
        join: us in Model.UserShow, on: us.show_id == s.id and us.user_id == ^user.id,
        order_by: s.name,
        select: {s, us.ignored})
      |> Enum.reduce(%{my_shows: [], canceled: [], ignored: []}, fn({show, ignored}, acc) ->
        cond do
          ignored -> %{my_shows: acc[:my_shows], canceled: acc[:canceled], ignored: acc[:ignored] ++ [show]}
          ["Canceled/Ended", "Canceled", "Ended"] |> Enum.member?(show.status) -> %{my_shows: acc[:my_shows], canceled: acc[:canceled] ++ [show], ignored: acc[:ignored]}
          true -> %{my_shows: acc[:my_shows] ++ [show], canceled: acc[:canceled], ignored: acc[:ignored]}
        end
      end)
  end

  def add_show(_user, nil), do: nil
  def add_show(user, show) do
    unless Repo.get_by(Model.UserShow, %{show_id: show.id, user_id: user.id}) do
      result =
        Model.UserShow.changeset(%Model.UserShow{}, %{
          user_id: user.id,
          show_id: show.id,
          modified: Timex.now,
          ignored: false,
          date_added: Timex.now
        }) |> Repo.insert

      case result do
        {:ok, _struct}       -> true
        {:error, _changeset} -> false
      end
    else
      true
    end
  end

  def get_user_device(user, device_type, device_code) do
    case Enum.member?(["browser", "api"], device_type) do
      # TODO do we want to take random device for specific device_type
      true -> Repo.one(from ud in Model.UserDevices, where: ud.user_id == ^user.id and ud.device_type == ^device_type, limit: 1)
      _    -> Repo.get_by(Model.UserDevices, %{user_id: user.id, device_code: device_code})
    end
  end

  def has_device(user, device_type, device_code) do
    get_user_device(user, device_type, device_code) != nil
  end

  def add_device(user, device_type) do
    if user_device = Model.UserDevices.create_device(user, device_type) do
      %{device_code: user_device.device_code}
    end
  end

  def add_device_visit(user, device_type, device_code) do
    if user_device = get_user_device(user, device_type, device_code) do
      udv = Model.UserDeviceVisit.last_device_visit(user_device)
      if !udv || Timex.diff(Timex.now, udv.date, :seconds) > 3600 do
        Model.UserDeviceVisit.add_user_visit(user_device)
      end
    else
      Logger.error("add_device_visit: user_device shouldn\'t be null for user '#{user.id}' with device(type: '#{device_type}', code: '#{device_code}')"); nil
    end
  end

  def get_last_login(user, device_type, device_code) do
    if user_device = get_user_device(user, device_type, device_code) do
      last_login = user_device.last_login
      Model.UserDevices.update_last_login(user_device)

      %{last_login: last_login}
    else
      %{last_login: user.date_joined}
    end
  end

  def authenticate(nil, _password), do: nil
  def authenticate(_username, nil), do: nil
  def authenticate(username, password) do
    if user = Repo.get_by(Model.User, username: username) do
      cond do
        user.password_new_hash && Comeonin.Bcrypt.checkpw(password, user.password_new_hash) -> user
        (s = user.password |> String.split("$")) && Enum.count(s) == 3 ->
          # validation for old passwords (SHA1)
          [_algorithm, salt, pass] = s
          calc_pass = :crypto.hash(:sha, "#{salt}#{password}") |> Base.encode16 |> String.downcase

          case String.equivalent?(pass, calc_pass) do
            true  -> user
            false -> nil
          end
        true -> nil
      end
    end
  end

  def get_auth_hash(user) do
    cond do
      user.auto_hash -> user.auto_hash
      true ->
        result =
          Model.User.changeset(user, %{auto_hash: UUID.uuid4()})
          |> Repo.update

        case result do
          {:ok, struct}        -> struct.auto_hash
          {:error, _changeset} -> Logger.error("Could't create auth_hash for user '#{user.id}'"); nil
        end
    end
  end
end
