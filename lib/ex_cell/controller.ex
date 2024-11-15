defmodule ExCell.Controller do
  alias ExCell.View

  @moduledoc """
  Cell methods that render a cell directly to a controller
  """
  @controller_adapter ExCell.config(:controller_adapter, Phoenix.Controller)

  @doc """
  Renders a cell directly from a controller without having to use a view.

  ## Examples
      defmodule AppWeb.UserController do
        use AppWeb, :controller
        import Cell.Controller

        def avatar(conn, _params) do
          conn
          |> cell(AvatarCell, user: conn.user)
        end
      end
  """

  def cell(cell) do
    cell(cell, [])
  end

  def cell(%Plug.Conn{assigns: assigns} = conn, cell) do
    cell(conn, cell, Map.to_list(assigns))
  end

  def cell(cell, assigns) do
    View.cell(cell, assigns)
  end

  def cell(%Plug.Conn{} = conn, cell, assigns) do
    assigns
    |> Enum.reduce(conn, fn {key, value}, conn -> Plug.Conn.assign(conn, key, value) end)
    |> @controller_adapter.put_view(cell)
    |> @controller_adapter.render("template.html")
  end
end
