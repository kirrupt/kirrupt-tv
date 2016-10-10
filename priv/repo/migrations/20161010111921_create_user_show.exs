defmodule KirruptTv.Repo.Migrations.CreateUserShow do
  use Ecto.Migration

  def change do
    create table(:users_shows) do

      timestamps()
    end

  end
end
