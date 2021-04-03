defmodule KirruptTv.Repo.Migrations.CreateUserDeviceVisit do
  use Ecto.Migration

  def change do
    create table(:users_device_visit) do
      add :user_id, :bigint, null: false, size: 255
      add :device_id, :bigint, null: false, size: 255
      add :date, :utc_datetime, null: false
    end
  end
end
