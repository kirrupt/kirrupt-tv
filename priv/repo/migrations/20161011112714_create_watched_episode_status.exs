defmodule KirruptTv.Repo.Migrations.CreateWatchedEpisodeStatus do
  use Ecto.Migration

  def change do
    create table(:watched_episodes_status, primary_key: false) do
      add :user_id, :bigint, primary_key: true, size: 255
      add :episode_id, :bigint, primary_key: true, size: 255
      add :status, :boolean, null: false
      add :modified, :utc_datetime, null: false
    end
  end
end
