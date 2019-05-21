defmodule ExCell.MockViewAdapter do
  @moduledoc false
  def render(cell, template, args), do: [cell, template, args]
  def render_to_string(cell, template, args), do: [cell, template, args]
  def live_render(conn, cell, args), do: [conn, cell, args]
end
