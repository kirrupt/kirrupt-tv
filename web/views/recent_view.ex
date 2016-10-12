defmodule KirruptTv.RecentView do
  use KirruptTv.Web, :view
  use Timex
  
  import KirruptTv.DateHelpers
  import KirruptTv.GlobalHelpers

  def title do
    'Recent'
  end
end
