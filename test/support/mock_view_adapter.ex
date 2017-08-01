defmodule ExCell.MockViewAdapter do
  def render(cell, template, args), do: [cell, template, args]
  def render_to_string(cell, template, args), do: [cell, template, args]
end
