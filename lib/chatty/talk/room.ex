defmodule Chatty.Talk.Room do
  use Ecto.Schema
  import Ecto.Changeset
  alias Chatty.Talk.Room

  schema "rooms" do
    field :description, :string
    field :name, :string
    field :topic, :string
    belongs_to :user, Chatty.Accounts.User
    timestamps()
  end

  @doc false
  def changeset(%Room{} = room, attrs) do
    room
    |> cast(attrs, [:name, :description, :topic])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> validate_length(:name, min: 5, max: 30)
    |> validate_length(:topic, min: 5, max: 120)
  end
end
