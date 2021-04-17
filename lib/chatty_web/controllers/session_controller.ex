defmodule ChattyWeb.SessionController do
  use ChattyWeb, :controller

  def new(conn, _) do
    render(conn, "new.html")
  end
end
