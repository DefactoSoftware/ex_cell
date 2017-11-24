defmodule ExCell do
  @moduledoc false
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
