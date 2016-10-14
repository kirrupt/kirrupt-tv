defmodule KirruptTv.Router do
  use KirruptTv.Web, :router

  if Application.get_env(:sentry, :dsn) do
    use Plug.ErrorHandler
    use Sentry.Plug
  end

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
    get "/", IndexController, :index
  end

  scope "/account/", KirruptTv do
    pipe_through :browser

    get  "/login", AccountController, :login # TODO: implement
    post "/login", AccountController, :login # TODO: implement
    get  "/my-account", AccountController, :account # TODO: implement
    get  "/register", AccountController, :register # TODO: implement
    post "/register", AccountController, :register # TODO: implement
    get  "/logout", AccountController, :logout # TODO: implement
  end

  scope "/tv/", KirruptTv do
    pipe_through :browser # Use the default browser stack

    get   "/", RecentController, :index
    get   "/search", PageController, :search
    get   "/search/kirrupt", PageController, :search_kirrupt
    get   "/search/tvmaze", PageController, :search_tvmaze
    get   "/time-wasted", TimeWastedController, :index
    get   "/my-shows", ShowController, :my_shows
    get   "/my-shows/:category", ShowController, :my_shows_category
    get   "/show/add", ShowController, :add
    get   "/show/:name", ShowController, :index
    get   "/show/:name/update", ShowController, :update
    get   "/show/:name/add", ShowController, :add_to_my_shows
    get   "/show/:name/list", ShowController, :list
    get   "/show/:name/season/:season", ShowController, :season
    get   "/show/:name/ignore", ShowController, :ignore
    get   "/show/:tvmaze_id/add/tvmaze", ShowController, :add_tvmaze
    get  "/genre/:name", GenreController, :index
    get "/episode/:id/mark_as_watched", EpisodeController, :mark_as_watched # TODO PATCH
    get "/episode/:id/mark_as_unwatched", EpisodeController, :mark_as_unwatched #TODO PATCH
  end

  # Other scopes may use custom stacks.
  # scope "/api", KirruptTv do
  #   pipe_through :api
  # end
end
