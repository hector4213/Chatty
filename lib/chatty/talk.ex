defmodule Chatty.Talk do
  alias Chatty.Repo
  alias Chatty.Talk.Room

  def list_rooms do
    Repo.all(Room)
  end

  def change_room(%Room{} = room) do
    Room.changeset(room, %{})
  end

  def create_room(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:rooms)
    |> Room.changeset(attrs)
    |> Repo.insert()
  end

  def update_room(%Room{} = room, attrs) do
    room
    |> Room.changeset(attrs)
    |> Repo.update()
  end

  def get_room!(id), do: Repo.get!(Room, id)

  def delete_room(%Room{} = room) do
    room
    |> Repo.delete()
  end
end
