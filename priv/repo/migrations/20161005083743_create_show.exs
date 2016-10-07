defmodule KirruptTv.Repo.Migrations.CreateShow do
  use Ecto.Migration

  def change do
    create table(:shows) do
      add :name, :string
      add :tvrage_url, :string
      add :runtime, :integer
      add :genre, :string
      add :status, :string
      add :added, :datetime
      add :last_checked, :datetime
      add :last_updated, :datetime
      add :wikipedia_url, :string
      add :picture_url, :string
      add :thumbnail_url, :string
      add :wikipedia_checked, :integer
      add :tvrage_id, :integer
      add :tvmaze_id, :integer
      add :year, :integer
      add :started, :date
      add :ended, :date
      add :origin_country, :string
      add :airtime, :string
      add :airday, :string
      add :timezone, :string
      add :summary, :text
      add :thetvdb_id, :integer
      add :fixed_thumb, :string
      add :fixed_background, :string
      add :fixed_banner, :string
      add :url, :string

      timestamps()
    end

  end
end
