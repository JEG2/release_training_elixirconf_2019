defmodule PhxExampleAppWeb.PageController do
  use PhxExampleAppWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
