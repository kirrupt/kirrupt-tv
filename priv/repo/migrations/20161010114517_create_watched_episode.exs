defmodule KirruptTv.Repo.Migrations.CreateWatchedEpisode do
  use Ecto.Migration

  def change do
    create table(:watched_episodes, primary_key: false) do
      add :user_id, :bigint, primary_key: true, size: 255
      add :episode_id, :bigint, primary_key: true, size: 255
      add :added, :datetime, null: false
    end

  end
end
