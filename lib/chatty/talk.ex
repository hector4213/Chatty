defmodule Chatty.Talk do
  alias Chatty.Repo
  alias Chatty.Talk.Room

  def list_rooms do
    Repo.all(Room)
  end

  def create_room(attrs \\ %{}) do
    %Room{}
    |> Room.changeset(attrs)
    |> Repo.insert()
  end
end
