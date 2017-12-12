defmodule ExCell.Adapters.CellJS do
  @moduledoc false

  @behaviour ExCell.Adapter

  alias Phoenix.HTML.Tag

  def void_elements(), do: [
    "area",
    "base",
    "br",
    "col",
    "command",
    "embed",
    "hr",
    "img",
    "input",
    "keygen",
    "link",
    "meta",
    "param",
    "source",
    "track",
    "wbr"
  ]

  def void_element?(tag) when is_atom(tag), do: void_element?(Atom.to_string(tag))
  def void_element?(tag), do: tag in void_elements()

  def data_attribute(name, data \\ [], params \\ %{})
  def data_attribute(name, nil, params), do: data_attribute(name, [], params)
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

    attributes = attributes(name, attributes, params)

    case void_element?(tag) do
      true -> Tag.tag(tag, attributes)
      false -> Tag.content_tag(tag, content, attributes)
    end
  end
end
