defmodule KirruptTv.Repo.Migrations.AddSearchShowsTable do
  use Ecto.Migration

  def change do
    create table(:search_shows, primary_key: false) do
      add :tvmaze_id, :integer, size: 255
      add :name, :string, null: false
      add :year, :integer, size: 255, null: true
      add :image, :string, null: true
    end
  end
end
