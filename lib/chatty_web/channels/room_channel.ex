defmodule ChattyWeb.RoomChannel do
  use ChattyWeb, :channel

  alias Chatty.Repo
  alias Chatty.Accounts.User

  def join("room:" <> room_id, _params, socket) do
    {:ok, %{channel: "room:#{room_id}"}, assign(socket, :room_id, room_id)}
  end

  def handle_in("message:add", %{"message" => body}, socket) do
    room_id = socket.assigns[:room_id]
    user = get_user(socket)
    message = %{body: body, user: %{username: user.username}}
    broadcast!(socket, "room:#{room_id}:new_message", message)
    {:reply, :ok, socket}
  end

  def get_user(socket) do
    Repo.get(User, socket.assigns[:current_user_id])
  end
end
