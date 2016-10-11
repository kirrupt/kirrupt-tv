defmodule Model.User do
  use KirruptTv.Web, :model
  use Timex

  import KirruptTv.DateHelpers
  import KirruptTv.Helpers.BackgroundHelpers

  alias KirruptTv.Repo
  alias Model.Episode
  alias Model.Genre
  alias Model.UserShow
  alias Model.WatchedEpisode

  schema "users" do
    field :username, :string
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :password, :string
    field :is_active, :boolean
    field :last_login, Timex.Ecto.DateTime
    field :date_joined, Timex.Ecto.DateTime
    field :auto_hash, :string
    field :registration_code, :string
    field :password_code, :string
    field :is_editor, :integer
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
    |> cast(params, [])
    |> validate_required([])
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
    tomorrow = time_delta(today, 1)
    yesterday = time_delta(today, -1)
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
end
