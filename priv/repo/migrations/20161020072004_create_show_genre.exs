defmodule KirruptTv.Repo.Migrations.CreateShowGenre do
  use Ecto.Migration

  def change do
    create table(:shows_genres, primary_key: false) do
      add :show_id, :bigint, null: false, size: 255
      add :genre_id, :integer, null: false, size: 255
    end

    create index(:shows_genres, [:show_id, :genre_id], name: :show_id, primary_key: true, unique: true)
  end
end
