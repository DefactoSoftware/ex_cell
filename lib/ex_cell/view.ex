defmodule ExCell.View do
  @moduledoc """
  Cell helpers used to render the cells in both Views and Cells
  """
  @view_adapter ExCell.config(:view_adapter, Phoenix.View)

  @doc """
  Returns the relative path of a module to the namespace. This method is used
  to determine the template path of the cell.

  ## Examples

      iex(0)> ExCell.View.relative_path(AppWeb.AvatarCell, AppWeb)
      "avatar"

      iex(1)> ExCell.View.relative_path(AppWeb.Namespace.AvatarCell, AppWeb)
      "namespace/avatar"
  """
  def relative_path(module, namespace) do
    module
    |> ExCell.module_relative_to(namespace)
    |> Enum.map(&Macro.underscore/1)
    |> Enum.join("/")
    |> String.replace_suffix("_cell", "")
  end

  @doc """
  Renders a cell in the view.

  ### Examples

      iex(0)> safe_to_string(AppWeb.AvatarView.cell(AvatarCell))
      "<div class=\"AvatarCell\" ...>"

      iex(1)> safe_to_string(AppWeb.AvatarView.cell(AvatarCell, do: "Foo"))
      "<div class=\"AvatarCell\" ...>Foo</div>"

      iex(2)> safe_to_string(AppWeb.AvatarView.cell(AvatarCell, user: %User{name: "Bar"}))
      "<div class=\"AvatarCell\" ...>Bar</div>"

      iex(3)> safe_to_string(AppWeb.AvatarView.cell(AvatarCell, %Plug.Conn{} |> assign(:user, %User{name: "Bar"})))
      "<div class=\"AvatarCell\" ...>Bar</div>"

      iex(4)> safe_to_string(AppWeb.AvatarView.cell(AvatarCell, "Hello"))
      "<div class=\"AvatarCell\" ...>Hello</div>"
  """
  def cell(cell), do: render_cell(cell, [])

  def cell(cell, do: children), do: render_cell(cell, children: children)

  def cell(cell, %Plug.Conn{assigns: assigns} = conn) when is_map(assigns),
    do: render_cell(cell, Map.to_list(Map.put(assigns, :conn, conn)))

  def cell(cell, assigns) when is_list(assigns), do: render_cell(cell, assigns)

  def cell(cell, children) do
    render_cell(cell, children: children)
  end

  def cell(cell, %Plug.Conn{assigns: assigns} = conn, do: children) when is_map(assigns),
    do:
      render_cell(cell,
        assigns
        |> Map.put(:conn, conn)
        |> Map.put(:children, children)
        |> Map.to_list())

  def cell(cell, assigns, do: children) when is_list(assigns) do
    render_cell(cell, [children: children] ++ assigns)
  end

  def cell(cell, children, %Plug.Conn{assigns: assigns} = conn) when is_map(assigns) do
    render_cell(cell,
      assigns
      |> Map.put(:conn, conn)
      |> Map.put(:children, children)
      |> Map.to_list())
  end

  def cell(cell, children, assigns) when is_list(assigns) do
    render_cell(cell, [children: children] ++ assigns)
  end

  @doc """
  Renders the cell directly as a string, used for testing purposes.

  ### Examples

      iex(0)> AppWeb.AvatarView.cell_to_string(AvatarCell)
      "<div class=\"AvatarCell\" ...>"

      iex(1)> AppWeb.AvatarView.cell_to_string(AvatarCell, do: "Foo")
      "<div class=\"AvatarCell\" ...>Foo</div>"

      iex(2)> AppWeb.AvatarView.cell_to_string(AvatarCell, user: %User{name: "Bar"})
      "<div class=\"AvatarCell\" ...>Bar</div>"
  """
  def cell_to_string(cell), do: render_cell_to_string(cell, [])

  def cell_to_string(cell, do: children), do: render_cell_to_string(cell, children: children)

  def cell_to_string(cell, assigns), do: render_cell_to_string(cell, assigns)

  def cell_to_string(cell, assigns, do: children) do
    render_cell_to_string(cell, [children: children] ++ assigns)
  end

  defp render_cell(cell, assigns) do
    @view_adapter.render(cell, "template.html", assigns)
  end

  defp render_cell_to_string(cell, assigns) do
    @view_adapter.render_to_string(cell, "template.html", assigns)
  end
end
