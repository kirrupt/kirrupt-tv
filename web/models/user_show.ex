defmodule Model.UserShow do
  use KirruptTv.Web, :model
  alias KirruptTv.Repo

  @primary_key false
  schema "users_shows" do
    field :ignored, :integer
    field :modified, Timex.Ecto.DateTime
    field :date_added, Timex.Ecto.DateTime

    belongs_to :user, Model.User, primary_key: true
    belongs_to :show, Model.Show, primary_key: true
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end

  def connection(user, show) do
    Repo.get_by(Model.UserShow, user_id: user.id, show_id: show.id)
  end
end
