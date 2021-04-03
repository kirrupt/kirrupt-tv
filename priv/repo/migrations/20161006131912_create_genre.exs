defmodule KirruptTv.Repo.Migrations.CreateGenre do
  use Ecto.Migration

  def change do
    create table(:genres) do
      add :name, :string, null: false
      add :url, :string
    end

    create index(:genres, [:name], name: :name, unique: true)
  end
end
