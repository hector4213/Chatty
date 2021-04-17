defmodule Chatty.Accounts do
  alias Chatty.Repo
  alias Chatty.Accounts.User

  def sign_in(email, password) do
    user = Repo.get_by(User, email: email)

    cond do
      user && user.password_hash == password ->
        {:ok, user}

      true ->
        {:error, :unauthorized}
    end
  end
end
