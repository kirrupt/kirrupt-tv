defmodule Model.UserDeviceVisit do
  require Logger
  use KirruptTv.Web, :model

  alias KirruptTv.Repo

  schema "users_device_visit" do
    belongs_to(:user, Model.User)
    belongs_to(:device, Model.UserDevices)

    timestamps(inserted_at: :date, updated_at: nil)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :device_id, :date])
    |> validate_required([])
  end

  #     udvr = UserDeviceVisit.query.filter_by(user_id=self.id, device_id=ud.id).order_by(UserDeviceVisit.date.desc()).first()

  def last_device_visit(user_device) do
    Repo.one(
      from(udv in Model.UserDeviceVisit,
        where: udv.user_id == ^user_device.user_id and udv.device_id == ^user_device.id,
        order_by: [desc: udv.date],
        limit: 1
      )
    )
  end

  def add_user_visit(user_device) do
    result =
      Model.UserDeviceVisit.changeset(%Model.UserDeviceVisit{}, %{
        user_id: user_device.user_id,
        device_id: user_device.id
      })
      |> Repo.insert()

    case result do
      {:ok, struct} ->
        struct

      {:error, _changeset} ->
        Logger.error("Could't add user visit for device '#{user_device.id}'")
        nil
    end
  end
end
