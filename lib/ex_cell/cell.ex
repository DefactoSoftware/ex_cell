defmodule ExCell.Cell do
  @moduledoc """
  Cell methods that can be overridden
  """
  alias Phoenix.HTML.Tag

  @doc false
  def name(module, namespace) do
    parts = case namespace do
      nil -> Module.split(module)
      _ -> ExCell.module_relative_to(module, namespace)
    end

    Enum.join(parts, "-")
  end

  @doc false
  def container(name, params \\ %{}, options \\ [], content \\ nil) do
    {tag, options} = Keyword.pop(options, :tag, :div)

    attributes = attributes(name, options, params)

    case content do
      nil -> Tag.tag(tag, attributes)
      _ -> Tag.content_tag(tag, content, attributes)
    end
  end

  @doc false
  def class_name(classes) when is_list(classes) do
    classes
    |> List.flatten
    |> Enum.reject(&is_nil/1)
    |> Enum.join(" ")
  end

  @doc false
  defp attributes(name, options, params) do
    {data, options} = Keyword.pop(options, :data)

    data = Enum.concat(
      (data || []),
      [cell: name, cell_params: Poison.encode!(params)]
    )

    options
    |> Keyword.put(:data, data)
    |> Enum.reject(&is_nil/1)
  end

  defmacro __using__(opts \\ []) do
    quote do
      import ExCell.View

      def name do
        cell_adapter().name(__MODULE__, unquote(opts[:namespace]))
      end

      def class_name, do: name()

      def params, do: %{}
      def params(values), do: Map.merge(params(), values)

      def container do
        container(%{}, [], [do: nil])
      end

      def container([do: content]) do
        container(%{}, [], [do: content])
      end

      def container(options) when is_list(options) do
        container(%{}, options, [do: nil])
      end

      def container(%{} = params) do
        container(params, [], [do: nil])
      end

      def container(options, [do: content]) when is_list(options) do
        container(%{}, options, [do: content])
      end

      def container(%{} = params, [do: content]) do
        container(params, [], [do: content])
      end

      def container(%{} = params, options, [do: content]) when is_list(options) do
        class_name = [class_name(), options[:class]]
                     |> cell_adapter().class_name()

        options = Keyword.put(options, :class, class_name)

        cell_adapter().container(name(), params(params), options, content)
      end

      defp cell_adapter, do: unquote(ExCell.config(:cell_adapter))

      defoverridable [name: 0, params: 0, class_name: 0]
    end
  end
end
