defmodule ExCell.Base do
  @moduledoc false
  alias Phoenix.HTML.Tag

  defmacro __using__(opts \\ []) do
    quote do
      import ExCell.View

      @namespace unquote(opts[:namespace])
      @dialyzer [{:no_match, relative_name: 2}]

      @doc """
      Returns the name of the module as a string. Module namespaces are replaced
      by a dash.

      ## Example

        iex(0)> AvatarCell.name()
        "AvatarCell"

        iex(1)> User.AvatarCell.name()
        "User-AvatarCell"
      """
      def name, do: relative_name(__MODULE__, @namespace)

      @doc """
      Generates the CSS class name based on the cell name. Can be overriden
      to pre- or postfix the class name or to create a distinct class name with
      CSS modules.

      ## Examples

          iex(0)> AvatarCell.class_name()
          "AvatarCell"
      """
      def class_name, do: name()

      @doc """
      Generates the HTML attribute name based on the cell name. Can be overriden
      to pre- or postfix the attribute name.

      ## Examples

          iex(0)> AvatarCell.attribute_name()
          "AvatarCell"
      """
      def attribute_name, do: name()

      @doc false
      def params, do: %{}

      @doc """
      Returns the container of a cell as a Phoenix.Tag.

          iex(0)> alias Phoenix.HTML.safe_to_string
          iex(1)> safe_to_string(AvatarCell.container)
          "<div class=\\"AvatarCell\\" data-cell=\\"AvatarCell\\" data-cell-params=\\"{}\\">"
      """
      def container, do: container(%{}, [], [do: nil])

      @doc """
      Returns the container of a cell as a Phoenix.Tag with it's content.

          iex(0)> alias Phoenix.HTML.safe_to_string
          iex(1)> safe_to_string(AvatarCell.container(do: "Hello"))
          "<div class=\\"AvatarCell\\" data-cell=\\"AvatarCell\\" data-cell-params=\\"{}\\">Hello</div>"
      """
      def container(do: content), do: container(%{}, [], [do: content])

      @doc """
      Returns the container of a cell as a Phoenix.Tag with options.

      ## Options

      Adds attributes to the HTML tag of the cell, the following options can be
      used to extend certain funtionality of the cell:

      - `:class` - adds a custom class name to the cell class
      - `:tag` - sets the tagname of the cell, defaults to `:div`
      - `:data` - adds data attributes to the default `data-cell` and `data-cell-params` data attributes

      ## Examples

          iex(0)> alias Phoenix.HTML.safe_to_string
          iex(1)> safe_to_string(AvatarCell.container(tag: :a, data: [foo: "bar"], class: "Moo", href: "/"))
          "<a class=\\"AvatarCell Moo\\" data-foo="bar" data-cell=\\"AvatarCell\\" data-cell-params=\\"{}\\">"
      """
      def container(options) when is_list(options), do: container(%{}, options, [do: nil])
      def container(options, [do: content]) when is_list(options), do: container(%{}, options, [do: content])

      @doc """
      Returns the container of a cell as a Phoenix.Tag with attributes added to
      the data-cell-params attribute. This is used to add parameters to `cell-js` cells.

      ## Examples

          iex(0)> alias Phoenix.HTML.safe_to_string
          iex(1)> safe_to_string(AvatarCell.container(%{ foo: "bar" }))
          "<a class=\\"AvatarCell\\" data-cell=\\"AvatarCell\\" data-cell-params=\\"{&quot;foo&quot;:&quot;bar&quot;}">"
      """
      def container(%{} = params), do: container(params, [], [do: nil])
      def container(%{} = params, [do: content]), do: container(params, [], [do: content])
      def container(%{} = params, options) when is_list(options), do: container(params, options, [do: nil])
      def container(%{} = params, options, [do: content]) when is_list(options), do: do_container(params, options, content)

      @doc """
      Combines the parameters set on the cell with custom parameters for a specific instance

      ## Examples

          iex(0)> AvatarCell.params
          %{hello: "world"}
          iex(0)> AvatarCell.params(%{foo: "bar"})
          %{hello: "world", foo: "bar"}
      """
      def params(values), do: Map.merge(params(), values)

      defp relative_name(module, namespace) do
        parts = case namespace do
          nil -> Module.split(module)
          _ -> ExCell.module_relative_to(module, namespace)
        end

        Enum.join(parts, "-")
      end

      defp do_container(params \\ %{}, options \\ [], content \\ nil) do
        {tag, options} = Keyword.pop(options, :tag, :div)

        class_name = [class_name()] ++ [options[:class]]
                     |> List.flatten
                     |> Enum.reject(&is_nil/1)
                     |> Enum.join(" ")

        options = Keyword.put(options, :class, class_name)

        attributes = attributes(attribute_name(), options, params(params))

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

      defoverridable [class_name: 0, attribute_name: 0, params: 0]
    end
  end
end
