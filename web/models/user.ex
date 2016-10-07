defmodule Model.User do
  use KirruptTv.Web, :model
  use Timex

  import KirruptTv.DateHelpers
  import KirruptTv.Helpers.BackgroundHelpers

  alias KirruptTv.Repo
  alias Model.Episode
  alias Model.Genre

  schema "users" do

  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end

  def public_overview(search \\ "") do
    today = Timex.today
    tomorrow = time_delta(today, 1)
    yesterday = time_delta(today, -1)
    fourteendays_ago = time_delta(today, -14)
    onemonthfromtoday = time_delta(today, 30)

    search = "%#{search}%"

    recent = Repo.all(
      from e in Episode,
      join: s in Model.Show, on: s.id == e.show_id,
      where: e.airdate > ^fourteendays_ago and e.airdate < ^today and fragment("DAY(?)", e.airdate) != 0 and like(s.name, ^search),
      order_by: [desc: e.airdate],
      limit: 10)
    |> Repo.preload([:show])

    soon = Repo.all(
      from e in Episode,
      join: s in Model.Show, on: s.id == e.show_id,
      where: e.airdate >= ^today and e.airdate < ^onemonthfromtoday and like(s.name, ^search),
      order_by: [asc: e.airdate],
      order_by: [asc: s.name],
      limit: 10)
    |> Repo.preload([:show])

    countdown = Repo.all(
      from e in Episode,
      join: s in Model.Show, on: s.id == e.show_id,
      where: e.airdate >= ^today and like(s.name, ^search),
      # group_by: s.id,
      order_by: [asc: e.airdate],
      order_by: [asc: s.name],
      order_by: [desc: e.episode],
      limit: 55)
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
