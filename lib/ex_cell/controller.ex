defmodule ExCell.Controller do
  @moduledoc """
  Cell methods that render a cell directly to a controller
  """
  defmacrop controller_adapter do
    ExCell.config(:controller_adapter, Phoenix.Controller)
  end

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
  def cell(conn, cell, assigns \\ []) do
    controller_adapter().render(conn, cell, "template.html", assigns)
  end
end
