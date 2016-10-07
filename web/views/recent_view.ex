defmodule KirruptTv.RecentView do
  use KirruptTv.Web, :view
  use Timex
  import KirruptTv.DateHelpers

  def title do
    'Recent'
  end
end
