defmodule KirruptTv.Repo.Migrations.CreateUserDevices do
  use Ecto.Migration

  def change do
    create table(:users_devices) do
      add :user_id, :bigint, null: false, size: 255
      add :device_type, :string, null: false
      add :device_code, :string, null: false
      add :first_login, :datetime, null: false
      add :last_login, :datetime, null: false
    end
  end
end
