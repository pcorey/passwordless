defmodule Passwordless.Router do
  use Passwordless.Web, :router

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

  scope "/", Passwordless do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    post "/create_token", PageController, :create_token
    get "/token/:token", PageController, :verify_token
    get "/logout", PageController, :logout
  end

  # Other scopes may use custom stacks.
  # scope "/api", Passwordless do
  #   pipe_through :api
  # end
end
