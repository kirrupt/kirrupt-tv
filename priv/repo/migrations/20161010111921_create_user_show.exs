defmodule KirruptTv.Repo.Migrations.CreateUserShow do
  use Ecto.Migration

  def change do
    create table(:users_shows, primary_key: false) do
      add :user_id, :bigint, primary_key: true, size: 255
      add :show_id, :bigint, primary_key: true, size: 255
      add :ignored, :boolean
      add :modified, :utc_datetime, null: false
      add :date_added, :utc_datetime
    end
  end
end
