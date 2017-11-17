defmodule ExCell.Adapters.CellJS do
  @behaviour ExCell.Adapter

  alias Phoenix.HTML.Tag

  def data_attribute(name, data \\ [], params \\ %{})
  def data_attribute(name, data, params) when is_nil(data), do:
    data_attribute(name, [], params)

  def data_attribute(name, data, params) when is_list(data) do
    data
    |> Keyword.merge(cell: name, cell_params: Poison.encode!(params))
  end

  def attributes(name, attributes \\ [], params \\ %{}) do
    Keyword.put(
      attributes,
      :data,
      data_attribute(name, Keyword.get(attributes, :data), params)
    )
  end

  def container(%{
    name: name,
    attributes: attributes,
    params: params,
    tag: tag,
    closing_tag: closing_tag,
    content: content
  }) do
    attributes = attributes(name, attributes, params)

    case closing_tag do
      false -> Tag.tag(tag, attributes)
      _ -> Tag.content_tag(tag, content, attributes)
    end
  end
end
