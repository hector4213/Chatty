defmodule ChattyWeb.SessionController do
  use ChattyWeb, :controller
  alias Chatty.Accounts

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case Accounts.sign_in(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "You are signed in")
        |> redirect(to: Routes.room_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "Invalid Email or Password")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Accounts.sign_out()
    |> redirect(to: Routes.room_path(conn, :index))
  end
end
