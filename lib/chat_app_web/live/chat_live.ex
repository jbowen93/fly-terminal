defmodule ChatAppWeb.ChatLive do
  use ChatAppWeb, :live_view

  alias ChatApp.Chat
  alias ChatApp.Chat.Message

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(ChatApp.PubSub, "chat:lobby")
    end

    messages = Chat.list_messages()
    changeset = Chat.change_message(%Message{})

    {:ok,
     socket
     |> assign(:form, to_form(changeset))
     |> assign(:username, "guest_#{:rand.uniform(9999)}")
     |> assign(:messages_empty?, messages == [])
     |> stream(:messages, messages)}
  end

  @impl true
  def handle_event("validate", %{"message" => message_params}, socket) do
    changeset =
      %Message{}
      |> Chat.change_message(message_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  @impl true
  def handle_event("send_message", %{"message" => message_params}, socket) do
    message_params = Map.put(message_params, "username", socket.assigns.username)

    case Chat.create_message(message_params) do
      {:ok, message} ->
        changeset = Chat.change_message(%Message{})

        {:noreply,
         socket
         |> assign(:form, to_form(changeset))
         |> assign(:messages_empty?, false)
         |> stream_insert(:messages, message, at: -1)}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  @impl true
  def handle_event("send_message", %{"key" => "Enter", "value" => content}, socket)
      when content != "" do
    message_params = %{"content" => content, "username" => socket.assigns.username}

    case Chat.create_message(message_params) do
      {:ok, message} ->
        changeset = Chat.change_message(%Message{})

        {:noreply,
         socket
         |> assign(:form, to_form(changeset))
         |> assign(:messages_empty?, false)
         |> stream_insert(:messages, message, at: -1)}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  @impl true
  def handle_event("send_message", %{"key" => "Enter", "value" => ""}, socket) do
    # Ignore empty messages on Enter key press
    {:noreply, socket}
  end

  @impl true
  def handle_event("set_username", %{"username" => username}, socket) do
    {:noreply, assign(socket, :username, username)}
  end

  @impl true
  def handle_info({:new_message, message}, socket) do
    {:noreply,
     socket
     |> assign(:messages_empty?, false)
     |> stream_insert(:messages, message, at: -1)}
  end

  defp format_time(datetime) do
    datetime
    |> DateTime.from_naive!("Etc/UTC")
    |> Calendar.strftime("%H:%M:%S")
  end
end
