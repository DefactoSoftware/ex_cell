defmodule ExCell.MockControllerAdapter do
  def render(conn, cell, template, args \\ []), do: [conn, cell, template, args]
  def render_to_string(conn, cell, template, args \\ []), do: [conn, cell, template, args]
end
