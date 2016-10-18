defmodule KirruptTv.Repo.Migrations.CreateUserDeviceVisit do
  use Ecto.Migration

  def change do
    create table(:users_device_visit) do

      timestamps()
    end

  end
end
