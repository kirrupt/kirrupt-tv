defmodule KirruptTv.Router do
  use KirruptTv.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", KirruptTv do
    pipe_through :browser # Use the default browser stack

    get   "/", RecentController, :index
    post  "/search", PageController, :search
    get   "/time-wasted", TimeWastedController, :index
    get   "/my-shows", ShowController, :my_shows
    get   "/my-shows/:category", ShowController, :my_shows_category
    get   "/show/:name", ShowController, :index
    get   "/show/:name/list", ShowController, :list
    get   "/show/:name/season/:season", ShowController, :season
    get   "/show/:name/ignore", ShowController, :ignore
    get "/episode/:id/mark_as_watched", EpisodeController, :mark_as_watched # TODO PATCH
    get "/episode/:id/mark_as_unwatched", EpisodeController, :mark_as_unwatched #TODO PATCH
  end

  # Other scopes may use custom stacks.
  # scope "/api", KirruptTv do
  #   pipe_through :api
  # end
end
