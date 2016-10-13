defmodule KirruptTv.PageView do
  use KirruptTv.Web, :view

  import KirruptTv.GlobalHelpers

  def is_my_show(my_shows, show) do
    my_shows |> Enum.member?(show)
  end
end
