defmodule ExCell.Cell do
  @moduledoc """
  Cell methods that can be overridden
  """
  alias Phoenix.HTML.Tag

  defmacro __using__(opts \\ []) do
    quote do
      import ExCell.View

      @namespace unquote(opts[:namespace])

      def name, do: relative_name()
      def class_name, do: name()
      def params, do: %{}

      def container, do: container(%{}, [], [do: nil])
      def container([do: content]), do: container(%{}, [], [do: content])

      def container(options) when is_list(options), do: container(%{}, options, [do: nil])
      def container(options, [do: content]) when is_list(options), do: container(%{}, options, [do: content])

      def container(%{} = params), do: container(params, [], [do: nil])
      def container(%{} = params, [do: content]), do: container(params, [], [do: content])
      def container(%{} = params, options) when is_list(options), do: container(params, options, [do: nil])
      def container(%{} = params, options, [do: content]) when is_list(options), do: do_container(params, options, content)

      @doc """
      Documentation
      """
      def params, do: %{}
      def params(values), do: Map.merge(params(), values)

      def class_name(classes) do
        [class_name()] ++ [classes]
        |> List.flatten
        |> Enum.reject(&is_nil/1)
        |> Enum.join(" ")
      end

      defp relative_name do
        parts = case @namespace do
          nil -> Module.split(__MODULE__)
          _ -> ExCell.module_relative_to(__MODULE__, @namespace)
        end

        Enum.join(parts, "-")
      end

      defp do_container(params \\ %{}, options \\ [], content \\ nil) do
        {tag, options} = Keyword.pop(options, :tag, :div)

        class_name = class_name(options[:class])
        options = Keyword.put(options, :class, class_name)

        attributes = attributes(name(), options, params(params))

        case content do
          nil -> Tag.tag(tag, attributes)
          _ -> Tag.content_tag(tag, content, attributes)
        end
      end

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

      defoverridable [name: 0, class_name: 0, params: 0]
    end
  end
end
