defmodule KirruptTv.Repo.Migrations.CreateEpisode do
  use Ecto.Migration

  def change do
    create table(:episodes) do
      add :show_id, :bigint, null: false, size: 255
      add :title, :string, null: false
      add :season, :integer, null: false, size: 255
      add :episode, :integer, null: false, size: 255
      add :tvrage_url, :string, null: false
      add :airdate, :datetime
      add :summary, :text
      add :screencap, :string

      timestamps(inserted_at: :added, updated_at: :last_updated)
    end

    create index(:episodes, [:show_id, :season, :episode], name: :show_id, unique: true)
    create index(:episodes, [:airdate], name: :airdate)
    create index(:episodes, [:show_id], name: :show_id_2)
    create index(:episodes, [:season], name: :season)
    create index(:episodes, [:episode], name: :episode)
  end
end
