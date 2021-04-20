defmodule ChattyWeb.RoomChannel do
  use ChattyWeb, :channel

  alias Chatty.Repo
  alias Chatty.Accounts.User
  alias ChattyWeb.Presence

  def join("room:" <> room_id, _params, socket) do
    send(self(), :after_join)
    {:ok, %{channel: "room:#{room_id}"}, assign(socket, :room_id, room_id)}
  end

  def handle_in("message:add", %{"message" => body}, socket) do
    room_id = socket.assigns[:room_id]
    user = get_user(socket)
    message = %{body: body, user: %{username: user.username}}
    broadcast!(socket, "room:#{room_id}:new_message", message)
    {:reply, :ok, socket}
  end

  def handle_info(:after_join, socket) do
    push(socket, "presence_state", Presence.list(socket))

    user = get_user(socket)

    {:ok, _} =
      Presence.track(socket, "user:#{user.id}", %{
        user_id: user.id,
        username: user.username
      })

    {:noreply, socket}
  end

  def get_user(socket) do
    Repo.get(User, socket.assigns[:current_user_id])
  end
end
