defmodule ExCell do
  @moduledoc """
  ExCell is used to split larger views in smaller cells that can be reused and
  easily packaged with Javascript and CSS.

  A cell consists of a couple of files:
  ```
  cells
  |- avatar
  |  |- template.html.eex
  |  |- view.html.eex
  |  |- style.css (optional)
  |  |- index.js (optional)
  |- header
  ...
  ```

  You can render the cell in a view, controller or another cell by adding the following code:
  ```ex
  cell(AvatarCell, class: "CustomClassName", user: %User{})
  ```

  This would generate the following HTML when you render the cell:

  ```html
  <span class="AvatarCell" data-cell="AvatarCell" data-cell-params="{}">
    <img src="/images/foo/avatar.jpg" class="AvatarCell-Image" alt="foo" />
  </span>
  ```
  """
  @dialyzer [{:no_match, relative_name: 2}]

  def module_relative_to(module, relative_to) do
    module
    |> Module.split
    |> Kernel.--(Module.split(relative_to))
  end

  def config(keyword, fallback \\ nil) do
    :ex_cell
    |> Application.get_env(__MODULE__, [])
    |> Keyword.get(keyword, fallback)
  end

  def relative_name(module, namespace) do
    parts = case namespace do
      nil -> Module.split(module)
      _ -> ExCell.module_relative_to(module, namespace)
    end

    Enum.join(parts, "-")
  end

  def class_name(name, classes) do
    [name, classes]
    |> List.flatten
    |> Enum.reject(&is_nil/1)
    |> Enum.join(" ")
  end

  def container(module, params, attributes, [do: content]) do
    module
    |> options(params, attributes, content)
    |> module.__adapter__().container()
  end

  def options(module, params, attributes, content) do
    %{
      name: module.cell_name(),
      params: module.params(params),
      attributes: Keyword.put(attributes, :class,
        class_name(module.class_name(), Keyword.get(attributes, :class))),
      content: content
    }
  end
end
