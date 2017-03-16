defmodule Passwordless.User do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def create_token(email) do
    GenServer.call(__MODULE__, {:create_token, email})
  end

  def lookup_user_from_token(token) do
    GenServer.call(__MODULE__, {:lookup_user_from_token, token})
  end

  def send_token(email, token) do
    IO.puts("Sending #{token} to #{email}.")
  end

  # def generate_token(), do: {:ok, Ecto.UUID.generate}
  def generate_token(email) do
    {:ok, Phoenix.Token.sign(Passwordless.Endpoint, "user", email, max_age: 5)}
  end

  def update_tokens(tokens, email, token) do
    {:ok, Map.put(tokens, token, email)}
  end

  def lookup_user(users, email) do
    {:ok, Map.get(users, email)}
  end

  def handle_call({:create_token, email}, _, tokens) do
    with {:ok, token} <- generate_token(email),
         {:ok, tokens} <- update_tokens(tokens, email, token)
    do
      send_token(email, token)
      {:reply, {:ok, token}, tokens}
    else
      _ -> {:reply, {:error, :user_not_found}, tokens}
    end
  end

  def handle_call({:lookup_user_from_token, token}, _, tokens) do
    {:reply, Map.get(tokens, token), tokens}
  end

end
