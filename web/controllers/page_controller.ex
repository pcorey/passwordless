defmodule Passwordless.PageController do
  use Passwordless.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
