defmodule ChattyWeb.RoomController do
  use ChattyWeb, :controller

  alias Chatty.Talk.Room
  alias Chatty.Talk

  plug ChattyWeb.Plugs.AuthUser when action not in [:index]

  def index(conn, _params) do
    rooms = Talk.list_rooms()
    render(conn, "index.html", rooms: rooms)
  end

  def new(conn, _params) do
    changeset = Room.changeset(%Room{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"room" => room_params}) do
    case Talk.create_room(room_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Room Created")
        |> redirect(to: Routes.room_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    room = Talk.get_room!(id)
    render(conn, "show.html", room: room)
  end

  def edit(conn, %{"id" => id}) do
    room = Talk.get_room!(id)
    changeset = Talk.change_room(room)
    render(conn, "edit.html", room: room, changeset: changeset)
  end

  def update(conn, %{"id" => id, "room" => room_params}) do
    room = Talk.get_room!(id)

    case Talk.update_room(room, room_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Room Updated")
        |> redirect(to: Routes.room_path(conn, :show, room))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", room: room, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    room = Talk.get_room!(id)
    {:ok, __room} = Talk.delete_room(room)

    conn
    |> put_flash(:info, "room deleted")
    |> redirect(to: Routes.room_path(conn, :index))
  end
end
