defmodule Model.SearchShow do
    require Logger
    use KirruptTv.Web, :model
    use Timex
  
    alias KirruptTv.Repo
  
    schema "search_shows" do
      field(:name, :string)
      field(:tvmaze_id, :integer)
      field(:year, :integer)
      field(:image, :string)
    end
  
    @doc """
    Builds a changeset based on the `struct` and `params`.
    """
    def changeset(struct, params \\ %{}) do
      struct
      |> cast(params, [
        :name,
        :tvmaze_id,
        :year,
        :image
      ])
      |> validate_required([:tvmaze_id, :name])
    end

    def update_all do
        tvmaze_shows = KirruptTv.Parser.TVMaze.all_shows()
        Repo.transaction(fn ->
            Repo.delete_all(Model.SearchShow)
            
            Enum.map(tvmaze_shows, fn (show) ->
                Repo.insert(Model.SearchShow.changeset(%Model.SearchShow{}, show))
            end)
        end)
    end
  end
