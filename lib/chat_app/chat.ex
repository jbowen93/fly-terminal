defmodule ChatApp.Chat do
  @moduledoc """
  The Chat context for managing messages.
  """

  import Ecto.Query, warn: false
  alias ChatApp.Repo
  alias ChatApp.Chat.Message

  @doc """
  Returns the list of messages ordered by most recent first.
  """
  def list_messages do
    Message
    |> order_by(asc: :inserted_at)
    |> Repo.all()
  end

  @doc """
  Creates a message and broadcasts it to all connected clients.
  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, message} ->
        # Broadcast the new message to all connected clients
        Phoenix.PubSub.broadcast(ChatApp.PubSub, "chat:lobby", {:new_message, message})
        {:ok, message}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.
  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end
end
