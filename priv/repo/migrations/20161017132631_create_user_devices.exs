defmodule KirruptTv.Repo.Migrations.CreateUserDevices do
  use Ecto.Migration

  def change do
    create table(:users_devices) do

      timestamps()
    end

  end
end
