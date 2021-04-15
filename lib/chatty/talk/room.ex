defmodule Chatty.Talk.Room do
  use Ecto.Schema
  import Ecto.Changeset
  alias Chatty.Talk.Room

  schema "rooms" do
    field :description, :string
    field :name, :string
    field :topic, :string

    timestamps()
  end

  @doc false
  def changeset(%Room{} = room, attrs) do
    room
    |> cast(attrs, [:name, :description, :topic])
    |> validate_required([:name,])
  end
end
