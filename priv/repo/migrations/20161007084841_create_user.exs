defmodule KirruptTv.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, null: false, size: 30
      add :first_name, :string, null: false, size: 30
      add :last_name, :string, null: false, size: 30
      add :email, :string, null: false, size: 75
      add :password, :string, null: false
      add :is_active, :boolean
      add :last_login, :datetime, null: false
      add :date_joined, :datetime, null: false
      add :auto_hash, :string
      add :registration_code, :string
      add :password_code, :string
      add :is_editor, :boolean, null: false
      add :is_developer, :boolean
      add :is_admin, :boolean
      add :skype_handle, :string
      add :google_id, :string
      add :google_session_id, :string
    end

    create index(:users, [:username], name: :username, unique: true)
  end
end
