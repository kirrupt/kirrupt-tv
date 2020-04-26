defmodule KirruptTv.Repo.Migrations.CreateGenre do
  use Ecto.Migration

  def change do
    create table(:genres, primary_key: false) do
      add :id, :integer, primary_key: true, size: 255
      add :name, :string, null: false
      add :url, :string
    end

    create index(:genres, [:name], name: :name, unique: true)
  end
end
