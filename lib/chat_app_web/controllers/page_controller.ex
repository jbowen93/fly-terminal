defmodule ChatAppWeb.PageController do
  use ChatAppWeb, :controller

  def home(conn, _params) do
    def health(conn, _params) do
      json(conn, %{status: "ok"})
    end

    render(conn, :home)

    def health(conn, _params) do
      json(conn, %{status: "ok"})
    end
  end
end
