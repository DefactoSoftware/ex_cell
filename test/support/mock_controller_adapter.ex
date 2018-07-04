defmodule ExCell.MockControllerAdapter do
  @moduledoc false
  def render(conn, template, args \\ []), do: [conn, template, args]
  def render_to_string(conn, cell, template, args \\ []), do: [conn, cell, template, args]
  def put_view(conn, cell), do: %{conn | private: %{phoenix_view: cell}}
end
