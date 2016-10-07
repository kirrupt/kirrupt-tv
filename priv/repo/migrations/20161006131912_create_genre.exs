defmodule KirruptTv.Repo.Migrations.CreateGenre do
  use Ecto.Migration

  def change do
    create table(:genres) do

      timestamps()
    end

  end
end
