defmodule KirruptTv.Router do
  use KirruptTv.Web, :router
  use Addict.RoutesHelper

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

  scope "/" do
    pipe_through :browser
    addict :routes,
      register: [path: "/account/register", controller: KirruptTv.AccountController, action: :register],
      login: [path: "/account/login", controller: KirruptTv.AccountController, action: :login],
      logout: [path: "/account/logout", controller: KirruptTv.AccountController, action: :logout]
  end

  scope "/", KirruptTv do
    get "/", IndexController, :index
  end

  scope "/account/", KirruptTv do
    pipe_through :browser

    get  "/login", AccountController, :login
    post "/login", AccountController, :login
    get  "/my-account", AccountController, :account # TODO: implement
    get  "/register", AccountController, :register_new
    post "/register", AccountController, :register_create
    get  "/logout", AccountController, :logout
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

  scope "/api/v2/", KirruptTv do
    pipe_through :api

    post "/login", Api.V2.AccountController, :login
    get  "/user/info", Api.V2.AccountController, :user_info
    get  "/shows", Api.V2.ShowController, :index
    post "/shows", Api.V2.ShowController, :index
    post "/shows/updated-dates", Api.V2.ShowController, :updated_dates
    post "/shows/episodes", Api.V2.ShowController, :episodes
    post "/shows/episodes/full", Api.V2.ShowController, :episodes_full
    post "/search/kirrupt", Api.V2.SearchController, :search_kirrupt
    post "/search/external", Api.V2.SearchController, :search_external
  end

  # Other scopes may use custom stacks.
  # scope "/api", KirruptTv do
  #   pipe_through :api
  # end
end
