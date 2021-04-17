defmodule ChattyWeb.RegistrationController do
  use ChattyWeb, :controller

  def new(conn, _) do
    render(conn, "new.html", changeset: conn)
  end

  def create(conn, params) do
    IO.puts("this is params")
    inspect(params)
    IO.puts("this is conn")
    conn
  end
end
