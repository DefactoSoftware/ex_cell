defmodule ExCell.MockCellAdapter do
  alias ExCell.Cell

  def name(module, namespace), do: Cell.name(module, namespace)
  def class_name(classes), do: Cell.class_name(classes)
  def container(name, params \\ %{}, options \\ [], content \\ nil) do
    [name, params, options, content]
  end
end
