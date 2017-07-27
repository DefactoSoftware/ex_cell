defmodule ExCell.View do
  @moduledoc """
  Cell helpers used to render the cells in both Views and Cells
  """
  def relative_path(module, namespace) do
    module
    |> ExCell.module_relative_to(namespace)
    |> Enum.map(&Macro.underscore/1)
    |> Enum.join("/")
    |> String.replace_suffix("_cell", "")
  end

  def cell(cell) do
    render_cell(cell, [])
  end
  def cell(cell, [do: children]) do
    render_cell(cell, children: children)
  end
  def cell(cell, assigns) when is_list(assigns) do
    render_cell(cell, assigns)
  end
  def cell(cell, children) do
    render_cell(cell, children: children)
  end
  def cell(cell, assigns, [do: children]) when is_list(assigns) do
    render_cell(cell, [children: children] ++ assigns)
  end
  def cell(cell, children, assigns) when is_list(assigns) do
    render_cell(cell, [children: children] ++ assigns)
  end

  def cell_to_string(cell) do
    render_cell_to_string(cell, [])
  end
  def cell_to_string(cell, [do: children]) do
    render_cell_to_string(cell, children: children)
  end
  def cell_to_string(cell, assigns) do
    render_cell_to_string(cell, assigns)
  end
  def cell_to_string(cell, assigns, [do: children]) do
    render_cell_to_string(cell, [children: children] ++ assigns)
  end

  defp render_cell(cell, assigns) do
    apply(cell.adapter, :render, [cell, "template.html", assigns])
  end

  defp render_cell_to_string(cell, assigns) do
    apply(cell.adapter, :render_to_string, [cell, "template.html", assigns])
  end
end
