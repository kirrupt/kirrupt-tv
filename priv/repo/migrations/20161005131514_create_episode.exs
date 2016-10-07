defmodule KirruptTv.Repo.Migrations.CreateEpisode do
  use Ecto.Migration

  def change do
    create table(:episodes) do

      timestamps()
    end

  end
end
