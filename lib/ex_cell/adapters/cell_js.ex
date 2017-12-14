defmodule ExCell.Adapters.CellJS do
  @moduledoc """
  The CellJS adapter can be used to output the cells as HTML compatible with
  [cells-js](https://github.com/DefactoSoftware/cells-js). CellsJS was written
  with ExCell in mind.

  Tags are automatically closed when they are part of the
  [void elements](https://stackoverflow.com/questions/4693939/self-closing-tags-void-elements-in-html5)
  specification.

  CellsJS uses two predefined attributes to parse the Javascript. First it
  will look for the `data-cell` cell attribute and match it to the defined Cell
  in Javascript.

  Second it will take the JSON arguments set on the `data-cell-params` attribute
  and use that to initialize the cell with user defined parameters.
  """

  @behaviour ExCell.Adapter

  alias Phoenix.HTML.Tag

  def void_elements, do: [
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

  @doc """
  The data_attribute function is used to build up the data attributes and set
  the default `data-cell` and `data-cell-params` attributes.
  """
  def data_attribute(name, id, data \\ [], params \\ %{}), do:
    Keyword.merge(data, cell: name, cell_id: id, cell_params: Poison.encode!(params))

  @doc """
  The attributes function is used to auto fill the attributes for a container
  with the data attributes.
  """
  def attributes(name, id, attributes \\ [], params \\ %{}) do
    Keyword.put(
      attributes,
      :data,
      data_attribute(name, id, Keyword.get(attributes, :data, []), params)
    )
  end

  @doc """
  The container renders HTML with the attributes, class name and data attributes
  prefilled. The HTML is rendered with Phoenix.HTML.Tag.
  """
  def container(%{
    name: name,
    attributes: attributes,
    params: params,
    content: content,
    id: id
  }) do
    {tag, attributes} = Keyword.pop(attributes, :tag, :div)

    attributes = attributes(name, id, attributes, params)

    case void_element?(tag) do
      true -> Tag.tag(tag, attributes)
      false -> Tag.content_tag(tag, content, attributes)
    end
  end
end
