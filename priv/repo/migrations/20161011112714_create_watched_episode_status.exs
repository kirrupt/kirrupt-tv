defmodule KirruptTv.Repo.Migrations.CreateWatchedEpisodeStatus do
  use Ecto.Migration

  def change do
    create table(:watched_episodes_status) do

      timestamps()
    end

  end
end
