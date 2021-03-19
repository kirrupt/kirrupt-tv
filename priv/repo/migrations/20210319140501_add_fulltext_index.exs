defmodule KirruptTv.Repo.Migrations.AddFulltextIndex do
  use Ecto.Migration

  def up do
    execute "create fulltext index search_shows_name_idx on search_shows (name)"
  end

  def down do
    execute "drop index search_shows_name_idx on search_shows"
  end
end
