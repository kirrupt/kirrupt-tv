defmodule Model.UserDevices do
  require Logger
  use KirruptTv.Web, :model

  alias KirruptTv.Repo

  schema "users_devices" do
    field(:device_type, :string)
    field(:device_code, :string)
    field(:last_login, Timex.Ecto.DateTime)

    belongs_to(:user, Model.User)
    timestamps(inserted_at: :first_login, updated_at: nil)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :device_type, :device_code, :first_login, :last_login])
    |> validate_required([:device_type, :device_code])
  end

  def create_device(user, device_type) do
    result =
      Model.UserDevices.changeset(%Model.UserDevices{}, %{
        user_id: user.id,
        device_type: device_type,
        device_code: UUID.uuid4(:hex) |> String.slice(0, 20),
        last_login: Timex.now()
      })
      |> Repo.insert()

    case result do
      {:ok, struct} ->
        struct

      {:error, _changeset} ->
        Logger.error("Could't create device for user '#{user.id}' with type '#{device_type}'")
        nil
    end
  end

  def update_last_login(user_device) do
    result =
      Model.UserDevices.changeset(user_device, %{last_login: Timex.now()})
      |> Repo.update()

    case result do
      {:ok, struct} ->
        struct

      {:error, _changeset} ->
        Logger.error("Could't update last login for device '#{user_device.id}'")
        nil
    end
  end
end
