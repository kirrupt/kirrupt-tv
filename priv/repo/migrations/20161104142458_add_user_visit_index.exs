defmodule KirruptTv.Repo.Migrations.AddUserVisitIndex do
  use Ecto.Migration

  def change do
    create index(:users_device_visit, [:user_id, :device_id], name: :user_device)
  end
end
