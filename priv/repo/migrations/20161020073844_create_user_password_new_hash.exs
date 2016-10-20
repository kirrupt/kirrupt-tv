defmodule KirruptTv.Repo.Migrations.CreateUserPasswordNewHash do
  use Ecto.Migration

  def change do

    alter table(:users) do
      add :password_new_hash, :string
    end
  end
end
