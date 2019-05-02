defmodule ExCell.LiveView do
  @moduledoc """
  Cell helpers used to render the live view cells in both Views and Cells
  """
  @view_adapter ExCell.config(:view_adapter, Phoenix.LiveView)

  @doc """
    Renders a cell in the view.

    ### Examples
        iex(0)> safe_to_string(AppWeb.AvatarView.live_cell(AvatarLiveCell, socket))
        "<div class=\"AvatarLiveCell\" ...>"
  """
  def live_cell(cell, conn_or_socket) do
    render_cell(cell, conn_or_socket, [])
  end

  @doc """
  Renders a cell in the view with children.

  ### Examples
      iex(0)> safe_to_string(AppWeb.AvatarView.live_cell(AvatarLiveCell, do: "Foo"))
      "<div class=\"AvatarLiveCell\" ...>Foo</div>"
  """
  def live_cell(cell, conn_or_socket, do: children) do
    render_cell(cell, conn_or_socket, children: children)
  end

  @doc """
  Renders a cell in the view with assigns.

  ### Examples
      iex(0)> safe_to_string(AppWeb.AvatarView.live_cell(AvatarLiveCell, user: %User{name: "Bar"}))
      "<div class=\"AvatarLiveCell\" ...>Bar</div>"
  """
  def live_cell(cell, conn_or_socket, assigns) when is_list(assigns) do
    render_cell(cell, conn_or_socket, assigns)
  end

  @doc """
  Renders a cell in the view with children without a block.

  ### Examples
      iex(0)> safe_to_string(AppWeb.AvatarView.live_cell(AvatarLiveCell, "Hello"))
      "<div class=\"AvatarLiveCell\" ...>Hello</div>"
  """
  def live_cell(cell, conn_or_socket, children) do
    render_cell(cell, conn_or_socket, children: children)
  end

  def live_cell(cell, conn_or_socket, assigns, do: children) when is_list(assigns) do
    render_cell(cell, conn_or_socket, [children: children] ++ assigns)
  end

  def live_cell(cell, conn_or_socket, children, assigns) when is_list(assigns) do
    render_cell(cell, conn_or_socket, [children: children] ++ assigns)
  end

  defp render_cell(cell, conn_or_socket, assigns) do
    assigns = Map.new(assigns)
    @view_adapter.live_render(conn_or_socket, cell, session: %{assigns: assigns})
  end
end
