defmodule KirruptTv.Repo.Migrations.CreateWatchedEpisode do
  use Ecto.Migration

  def change do
    create table(:watched_episodes) do

      timestamps()
    end

  end
end
