defmodule CalculatorWeb.Router do
  use CalculatorWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, {CalculatorWeb.LayoutView, :root}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CalculatorWeb do
    pipe_through :browser

    get "/", PageController, :index

    live "/calculator", CalculatorLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", CalculatorWeb do
  #   pipe_through :api
  # end
end
