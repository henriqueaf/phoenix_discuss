defmodule PhoenixDiscussWeb.Router do
  use PhoenixDiscussWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug PhoenixDiscussWeb.Plugs.SetUser
    plug :set_user_token_for_websocket
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhoenixDiscussWeb do
    pipe_through :browser # Use the default browser stack

    get "/", TopicController, :index
    resources "/topics", TopicController, except: [:index]
  end

  scope "/auth", PhoenixDiscussWeb do
    pipe_through :browser

    delete "/signout", AuthController, :signout
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhoenixDiscussWeb do
  #   pipe_through :api
  # end

  defp set_user_token_for_websocket(conn, _) do
    if current_user = conn.assigns.user do
      token = Phoenix.Token.sign(conn, "user socket", current_user.id)
      assign(conn, :user_token, token)
    else
      conn
    end
  end
end
