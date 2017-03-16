defmodule Passwordless.PageController do
  use Passwordless.Web, :controller

  def index(conn, _params) do
    render(conn, "index.html", current_user: get_session(conn, :current_user))
  end

  def create_token(conn, %{"email" => email}) do
    case Passwordless.User.create_token(email) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Token sent!")
        |> redirect(to: "/")
      {:error, :user_not_found} ->
        conn
        |> put_flash(:error, "Let's pretend we have an error.")
    end
  end

  def verify_token(conn, %{"token" => token}) do
    case Passwordless.User.lookup_user_from_token(token) do
      nil ->
        conn
        |> put_flash(:error, "Invalid token")
        |> redirect(to: "/")
      email ->
        conn
        |> put_session(:current_user, email)
        |> put_flash(:info, "Logged in!")
        |> redirect(to: "/")
    end
  end

  def logout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end
end
