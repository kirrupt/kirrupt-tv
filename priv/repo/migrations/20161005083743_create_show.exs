defmodule KirruptTv.Repo.Migrations.CreateShow do
  use Ecto.Migration

  def up do
    create table(:shows) do
      add :name, :string, null: false
      add :tvrage_url, :string
      add :runtime, :integer, size: 255
      add :genre, :string, null: false
      add :status, :string, null: false
      add :last_checked, :utc_datetime
      add :wikipedia_url, :string
      add :picture_url, :string
      add :thumbnail_url, :string
      add :wikipedia_checked, :boolean, null: false
      add :tvrage_id, :integer, size: 255
      add :tvmaze_id, :integer, size: 255
      add :year, :integer, size: 255
      add :started, :date
      add :ended, :date
      add :origin_country, :string, size: 50
      add :airtime, :string, size: 50
      add :airday, :string, size: 50
      add :timezone, :string, size: 50
      add :summary, :text
      add :thetvdb_id, :string
      add :fixed_thumb, :string
      add :fixed_background, :string
      add :fixed_banner, :string
      add :url, :string

      timestamps(inserted_at: :added, updated_at: :last_updated)
    end

    execute "CREATE FULLTEXT INDEX name_2 ON shows(name);"
  end

  def down do
    drop table(:shows)
  end
end
