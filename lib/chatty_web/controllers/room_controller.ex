defmodule ChattyWeb.RoomController do
  use ChattyWeb, :controller

  alias Chatty.Talk.Room

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new(conn, _params) do
    changeset = Room.changeset(%Room{}, %{})
    render(conn, "new.html", changeset: changeset)
  end
end