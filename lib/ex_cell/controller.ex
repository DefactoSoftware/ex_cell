defmodule ExCell.Controller do
  @moduledoc """
  Cell methods that render a cell directly to a controller
  """
  alias ExCell.Controller

  defmacro __using__(opts \\ []) do
    quote do
      def cell(conn, cell, assigns \\ []) do
        Controller.cell(
          unquote(opts[:adapter]),
          conn,
          cell,
          assigns
        )
      end
    end
  end

  def cell(adapter, conn, cell, assigns \\ []) do
    adapter.render(conn, cell, "template.html", assigns)
  end
end
