defmodule ExCell.Controller do
  @moduledoc """
  Cell methods that render a cell directly to a controller
  """
  defmacrop controller_adapter do
    ExCell.config(:controller_adapter, Phoenix.Controller)
  end

  def cell(conn, cell, assigns \\ []) do
    controller_adapter().render(conn, cell, "template.html", assigns)
  end
end
