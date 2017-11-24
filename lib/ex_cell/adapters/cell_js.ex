defmodule ExCell.Adapters.CellJS do
  @moduledoc false

  @behaviour ExCell.Adapter

  alias Phoenix.HTML.Tag

  def data_attribute(name, data \\ [], params \\ %{})
  def data_attribute(name, data, params) when is_nil(data), do:
    data_attribute(name, [], params)
  def data_attribute(name, data, params) when is_list(data), do:
    Keyword.merge(data, cell: name, cell_params: Poison.encode!(params))

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
    content: content
  }) do
    {tag, attributes} = Keyword.pop(attributes, :tag, :div)
    {closing_tag, attributes} = Keyword.pop(attributes, :closing_tag, true)

    attributes = attributes(name, attributes, params)

    case closing_tag do
      false -> Tag.tag(tag, attributes)
      _ -> Tag.content_tag(tag, content, attributes)
    end
  end
end
