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

    get  "/", RecentController, :index
    post "/search", PageController, :search
    get  "/show/:name", ShowController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", KirruptTv do
  #   pipe_through :api
  # end
end
