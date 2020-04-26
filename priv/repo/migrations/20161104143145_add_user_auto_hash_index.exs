defmodule KirruptTv.Repo.Migrations.AddUserAutoHashIndex do
  use Ecto.Migration

  def change do
    create index(:users, [:auto_hash], name: :auto_hash)
  end
end
