defmodule KirruptTv.Router do
  use KirruptTv.Web, :router
  import Phoenix.LiveDashboard.Router

  defp inject_pipeline_name(conn, name) do
    Plug.Conn.put_private(conn, :pipeline_name, name)
  end

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:inject_pipeline_name, :browser)
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
    plug(:inject_pipeline_name, :api)
    plug(KirruptTv.Plugs.ServerTime)
  end

  pipeline :admin do
    plug(KirruptTv.Plugs.Authenticate)
    plug(KirruptTv.Plugs.Authenticated.Admin)
  end

  scope "/", KirruptTv do
    get("/thumbs/:thumb_type/*image_path", ThumbController, :index)
  end

  scope "/admin/", KirruptTv do
    pipe_through([:browser, :admin])

    live_dashboard("/dashboard", metrics: KirruptTv.Telemetry)
  end

  scope "/account/", KirruptTv do
    pipe_through(:browser)

    get("/login", AccountController, :login)
    post("/login", AccountController, :login)
    # TODO: implement
    get("/my-account", AccountController, :account)
    get("/register", AccountController, :register_new)
    post("/register", AccountController, :register_create)
    get("/logout", AccountController, :logout)
  end

  scope "/", KirruptTv do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", RecentController, :index)
    get("/search", PageController, :search)
    get("/search/kirrupt", PageController, :search_kirrupt)
    get("/search/tvmaze", PageController, :search_tvmaze)
    get("/time-wasted", TimeWastedController, :index)
    get("/my-shows", ShowController, :my_shows)
    get("/my-shows/:category", ShowController, :my_shows_category)
    get("/show/add", ShowController, :add)
    get("/show/:name", ShowController, :index)
    get("/show/:name/update", ShowController, :update)
    get("/show/:name/add", ShowController, :add_to_my_shows)
    get("/show/:name/list", ShowController, :list)
    get("/show/:name/season/:season", ShowController, :season)
    get("/show/:name/ignore", ShowController, :ignore)
    get("/show/:tvmaze_id/add/tvmaze", ShowController, :add_tvmaze)
    get("/genre/:name", GenreController, :index)
    # TODO PATCH
    get("/episode/:id/mark_as_watched", EpisodeController, :mark_as_watched)
    # TODO PATCH
    get("/episode/:id/mark_as_unwatched", EpisodeController, :mark_as_unwatched)
  end
end
