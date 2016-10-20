defmodule KirruptTv.Repo.Migrations.CreateUserDeviceVisit do
  use Ecto.Migration

  def change do
    create table(:users_device_visit, primary_key: false) do
      add :id, :bigint, primary_key: true, size: 255
      add :user_id, :bigint, null: false, size: 255
      add :device_id, :bigint, null: false, size: 255
      add :date, :datetime, null: false
    end
  end
end
