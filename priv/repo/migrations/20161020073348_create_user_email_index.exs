defmodule KirruptTv.Repo.Migrations.CreateUserEmailIndex do
  use Ecto.Migration

  def change do
    create index(:users, [:email], name: :email_index, unique: true)
  end
end
