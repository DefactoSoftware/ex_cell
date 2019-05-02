defmodule ExCell.Base do
  @moduledoc false

  defmacro __using__(opts \\ []) do
    quote do
      import ExCell.View
      import ExCell.LiveView

      @adapter unquote(opts[:adapter])
      @namespace unquote(opts[:namespace])

      @doc """
      Returns the name of the module as a string. Module namespaces are replaced
      by a dash.

      ## Example

        iex(0)> AvatarCell.name()
        "AvatarCell"

        iex(1)> User.AvatarCell.name()
        "User-AvatarCell"
      """
      def __adapter__, do: @adapter
      def name, do: ExCell.relative_name(__MODULE__, @namespace)

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

          iex(0)> AvatarCell.cell_name()
          "AvatarCell"
      """
      def cell_name, do: name()

      @doc false
      def params, do: %{}

      @doc """
      Combines the parameters set on the cell with custom parameters for a
      specific instance

      ## Examples

          iex(0)> AvatarCell.params
          %{hello: "world"}
          iex(0)> AvatarCell.params(%{foo: "bar"})
          %{hello: "world", foo: "bar"}
      """
      def params(values), do: Map.merge(params(), values)

      @doc """
      Returns the container of a cell as a Phoenix.Tag.

          iex(0)> Phoenix.HTML.safe_to_string(AvatarCell.container)
          "<div class=\\"AvatarCell\\" data-cell=\\"AvatarCell\\" data-cell-params=\\"{}\\">"
      """
      def container, do: container(%{}, [], do: nil)

      @doc """
      Returns the container of a cell as a Phoenix.Tag with it's content.

          iex(0)> Phoenix.HTML.safe_to_string(AvatarCell.container(do: "Hello"))
          "<div class=\\"AvatarCell\\" data-cell=\\"AvatarCell\\" data-cell-params=\\"{}\\">Hello</div>"
      """
      def container(do: content), do: container(%{}, [], do: content)
      def container(callback) when is_function(callback), do: container(%{}, [], callback)

      @doc """
      Returns the container of a cell as a Phoenix.Tag with options.

      ## Options

      Adds attributes to the HTML tag of the cell, the following options can be
      used to extend certain funtionality of the cell:

      - `:class` - adds a custom class name to the cell class
      - `:tag` - sets the tagname of the cell, defaults to `:div`
      - `:data` - adds data attributes to the default `data-cell` and `data-cell-params` data attributes

      ## Examples

          iex(0)> Phoenix.HTML.safe_to_string(AvatarCell.container(tag: :a, data: [foo: "bar"], class: "Moo", href: "/"))
          "<a class=\\"AvatarCell Moo\\" data-foo="bar" data-cell=\\"AvatarCell\\" data-cell-params=\\"{}\\">"
      """
      def container(options) when is_list(options), do: container(%{}, options, do: nil)
      def container(options, content) when is_list(options), do: container(%{}, options, content)

      @doc """
      Returns the container of a cell as a Phoenix.Tag with attributes added to
      the data-cell-params attribute. This is used to add parameters to `cell-js` cells.

      ## Examples

          iex(0)> Phoenix.HTML.safe_to_string(AvatarCell.container(%{ foo: "bar" }))
          "<a class=\\"AvatarCell\\" data-cell=\\"AvatarCell\\" data-cell-params=\\"{&quot;foo&quot;:&quot;bar&quot;}">"
      """
      def container(%{} = params), do: container(params, [], do: nil)
      def container(%{} = params, do: content), do: container(params, [], do: content)

      def container(%{} = params, callback) when is_function(callback),
        do: container(params, [], callback)

      def container(%{} = params, options) when is_list(options),
        do: container(params, options, do: nil)

      def container(%{} = params, options, content),
        do: ExCell.container(__MODULE__, UUID.uuid4(), params, options, content)

      defoverridable class_name: 0, cell_name: 0, params: 0
    end
  end
end
