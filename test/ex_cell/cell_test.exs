defmodule ExCell.CellTest do
  use ExUnit.Case
  import Phoenix.HTML

  alias ExCell.Cell
  alias Phoenix.HTML.Tag

  describe "name/2" do
    defmodule Foo.MockCell do
    end

    defmodule Foo.Bar.MockCell do
    end

    test "returns the relative module name" do
      assert Cell.name(Foo.MockCell, Foo) == "MockCell"
    end

    test "returns the relative module name with dashes for nested cells" do
      assert Cell.name(Foo.Bar.MockCell, Foo) == "Bar-MockCell"
    end
  end

  describe "container/4" do
    test "defaults to a :div as tag" do
      assert safe_to_string(Cell.container("MockCell"))
        == "<div data-cell=\"MockCell\" data-cell-params=\"{}\">"
    end

    test "custom tag" do
      assert safe_to_string(Cell.container("MockCell", %{}, [tag: :p]))
        == "<p data-cell=\"MockCell\" data-cell-params=\"{}\">"
    end

    test "content" do
      assert safe_to_string(Cell.container("MockCell", %{}, [], "TestContent"))
        == "<div data-cell=\"MockCell\" data-cell-params=\"{}\">TestContent</div>"
    end

    test "unsafe content" do
      assert safe_to_string(
        Cell.container("MockCell", %{}, [], Tag.content_tag(:div, "TestContent"))
      ) == "<div data-cell=\"MockCell\" data-cell-params=\"{}\"><div>TestContent</div></div>"
    end

    test "cell params" do
      assert safe_to_string(
        Cell.container("MockCell", %{ foo: "bar" })
      ) == "<div data-cell=\"MockCell\" data-cell-params=\"{&quot;foo&quot;:&quot;bar&quot;}\">"
    end

    test "attributes" do
      assert safe_to_string(
        Cell.container("MockCell", %{}, foo: "bar")
      ) == "<div data-cell=\"MockCell\" data-cell-params=\"{}\" foo=\"bar\">"
    end

    test "data attributes" do
      assert safe_to_string(
        Cell.container("MockCell", %{}, data: [foo: "bar"])
      ) == "<div data-cell=\"MockCell\" data-cell-params=\"{}\" data-foo=\"bar\">"
    end
  end

  describe "class_name/1" do
    test "joins multiple class names" do
      assert Cell.class_name(["foo", "bar"]) == "foo bar"
    end

    test "joins nested class names" do
      assert Cell.class_name(["foo", ["bar", "moo"]]) == "foo bar moo"
    end

    test "removes nill values" do
      assert Cell.class_name(["foo", nil]) == "foo"
    end
  end

  describe "__using__" do
    defmodule MockViewAdapter do
      def render(cell, template, args), do: [cell, template, args]
      def render_to_string(cell, template, args), do: [cell, template, args]
    end

    defmodule MockCellAdapter do
      def name(module, namespace), do: Cell.name(module, namespace)
      def class_name(classes), do: Cell.class_name(classes)
      def container(name, params \\ %{}, options \\ [], content \\ nil) do
        [name, params, options, content]
      end
    end

    defmodule MockCell do
      use Cell, adapter: MockViewAdapter,
                cell_adapter: MockCellAdapter,
                namespace: ExCell.CellTest
    end

    defmodule MockCellWithoutNamespace do
      use Cell, adapter: MockViewAdapter,
                cell_adapter: MockCellAdapter
    end

    defmodule MockCellWithOverrideables do
      use Cell, adapter: MockViewAdapter,
                cell_adapter: MockCellAdapter,
                namespace: ExCell.CellTest

      def name do
        "HelloWorld"
      end

      def class_name do
        "FooBar"
      end

      def params do
        %{ foo: "Bar" }
      end
    end

    test "name()" do
      assert MockCell.name == "MockCell"
    end

    test "name() without namespace" do
      assert MockCellWithoutNamespace.name
        == "ExCell-CellTest-MockCellWithoutNamespace"
    end

    test "name() is overrideable" do
      assert MockCellWithOverrideables.name
        == "HelloWorld"
    end

    test "class_name()" do
      assert MockCell.class_name == "MockCell"
    end

    test "class_name() without namespace" do
      assert MockCellWithoutNamespace.class_name
        == "ExCell-CellTest-MockCellWithoutNamespace"
    end

    test "class_name() is overrideable" do
      assert MockCellWithOverrideables.class_name == "FooBar"
    end

    test "container()" do
      assert MockCell.container == [
        "MockCell",
        %{},
        [class: "MockCell"],
        nil
      ]
    end

    test "container([do: content])" do
      assert MockCell.container(do: "Foo") == [
        "MockCell",
        %{},
        [class: "MockCell"],
        "Foo"
      ]
    end

    test "container(options) when is_list(options)" do
      assert MockCell.container(foo: "Bar") == [
        "MockCell",
        %{},
        [class: "MockCell", foo: "Bar"],
        nil
      ]
    end

    test "container(%{} = params)" do
      assert MockCell.container(%{foo: "Bar"}) == [
        "MockCell",
        %{foo: "Bar"},
        [class: "MockCell"],
        nil
      ]
    end

    test "container(options, [do: content]) when is_list(options)" do
      assert MockCell.container([foo: "Bar"], do: "Moo") == [
        "MockCell",
        %{},
        [class: "MockCell", foo: "Bar"],
        "Moo"
      ]
    end

    test "container(%{} = params, [do: content])" do
      assert MockCell.container(%{ foo: "Bar" }, do: "Moo") == [
        "MockCell",
        %{foo: "Bar"},
        [class: "MockCell"],
        "Moo"
      ]
    end

    test "container(%{} = params, options, [do: content]) when is_list(options)" do
      assert MockCell.container(%{ foo: "Bar" }, [hello: "World"], do: "Moo") == [
        "MockCell",
        %{foo: "Bar"},
        [class: "MockCell", hello: "World"],
        "Moo"
      ]
    end

    test "params()" do
      assert MockCell.params == %{}
    end

    test "params() with overrideables" do
      assert MockCellWithOverrideables.params() == %{foo: "Bar"}
    end

    test "params(values)" do
      assert MockCell.params(%{ hello: "World" }) == %{hello: "World"}
    end

    test "params(values) with overrideables" do
      assert MockCellWithOverrideables.params(%{hello: "World"})
        == %{foo: "Bar", hello: "World"}
    end
  end
end
