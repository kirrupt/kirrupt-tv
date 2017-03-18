defmodule Model.Recommendations do
  require Logger
  use KirruptTv.Web, :model
  alias KirruptTv.Repo

  defp get_shows(items, num) do
    items = Enum.uniq(items)
    count = round(Float.floor(num/2))
    {best, others} = Enum.split(items, count)
    out = Enum.shuffle(best ++ Enum.take_random(others, num - count))

    Repo.all(
      from s in Model.Show,
      where: s.id in ^out)
  end

  def show(id) do
    result = Ecto.Adapters.SQL.query!(Repo, "SELECT mid2,
        (weight*similarity) as o
      FROM  `recommendation_item_similarity`
      WHERE mid1 = ?
      ORDER BY o DESC
      LIMIT 0 , 50", [id]).rows
    |> Enum.map(fn([id, o]) ->
      id
    end)
    |> get_shows(4)
  end

  def user(user) do
    my_shows = Ecto.Adapters.SQL.query!(Repo, "SELECT mid
     FROM  `recommendation_top_users_ratings`
     WHERE  `uid` = ?
     ORDER BY `rating` DESC", [user.id]).rows
   |> Enum.map(fn([id]) ->
     id
   end)

   Ecto.Adapters.SQL.query!(Repo, "SELECT mid2, (similarity*weight) as o
    FROM  `recommendation_item_similarity`
    LEFT JOIN recommendation_top_users_ratings us
    ON us.mid = mid2 AND us.uid = ?
    where us.uid is null
    AND mid1 in (" <> Enum.join(my_shows, ",") <> ")
    ORDER BY o DESC
    LIMIT 100", [user.id]).rows
    |> Enum.map(fn([id, o]) ->
      id
    end)
    |> get_shows(4)
  end
end
