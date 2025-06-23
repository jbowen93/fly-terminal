defmodule ChatApp.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :content, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :username])
    |> validate_required([:content, :username])
    |> validate_length(:content, min: 1, max: 1000)
    |> validate_length(:username, min: 1, max: 50)
  end
end
