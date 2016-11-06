defmodule KirruptTv.Repo.Migrations.AddIsPremiumToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :is_premium, :boolean
    end
  end
end
