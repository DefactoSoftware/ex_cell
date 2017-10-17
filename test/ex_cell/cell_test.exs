defmodule ExCell.CellTest do
  use ExUnit.Case
  import Phoenix.HTML

  alias ExCell.Cell
  alias Phoenix.HTML.Tag

  defmodule Foo.MockCell do
    use Cell, namespace: Foo
  end

  defmodule Foo.Bar.MockCell do
    use Cell, namespace: Foo
  end

  defmodule Foo.MockCellWithOverridables do
    use Cell, namespace: Foo

    def params, do: %{foo: "Bar"}
    def class_name, do: "Bar-" <> name()
    def attribute_name, do: "World-" <> name()
  end

  alias Foo.Bar
  alias Foo.MockCell
  alias Foo.MockCellWithOverridables

  describe "name/0" do
    test "returns the relative module name" do
      assert MockCell.name() == "MockCell"
    end

    test "returns the relative module name with dashes for nested cells" do
      assert Bar.MockCell.name() == "Bar-MockCell"
    end
  end

  describe "container/3" do
    test "defaults to a :div as tag" do
      assert safe_to_string(MockCell.container())
        == "<div class=\"MockCell\" data-cell=\"MockCell\" data-cell-params=\"{}\"></div>"
    end

    test "overrideables" do
      assert safe_to_string(MockCellWithOverridables.container())
        == "<div class=\"Bar-MockCellWithOverridables\" data-cell=\"World-MockCellWithOverridables\" data-cell-params=\"{&quot;foo&quot;:&quot;Bar&quot;}\"></div>"
    end

    test "custom tag" do
      assert safe_to_string(MockCell.container(%{}, tag: :p))
        == "<p class=\"MockCell\" data-cell=\"MockCell\" data-cell-params=\"{}\"></p>"
    end

    test "content" do
      assert safe_to_string(MockCell.container(%{}, [], do: "TestContent"))
        == "<div class=\"MockCell\" data-cell=\"MockCell\" data-cell-params=\"{}\">TestContent</div>"
    end

    test "unsafe content" do
      assert safe_to_string(
        MockCell.container(%{}, [], do: Tag.content_tag(:div, "TestContent"))
      ) == "<div class=\"MockCell\" data-cell=\"MockCell\" data-cell-params=\"{}\"><div>TestContent</div></div>"
    end

    test "cell params" do
      assert safe_to_string(
        MockCell.container(%{ foo: "bar" })
      ) == "<div class=\"MockCell\" data-cell=\"MockCell\" data-cell-params=\"{&quot;foo&quot;:&quot;bar&quot;}\"></div>"
    end

    test "attributes" do
      assert safe_to_string(
        MockCell.container(%{}, foo: "bar")
      ) == "<div class=\"MockCell\" data-cell=\"MockCell\" data-cell-params=\"{}\" foo=\"bar\"></div>"
    end

    test "data attributes" do
      assert safe_to_string(
        MockCell.container(%{}, data: [foo: "bar"])
      ) == "<div class=\"MockCell\" data-cell=\"MockCell\" data-cell-params=\"{}\" data-foo=\"bar\"></div>"
    end

    test "no closing tag" do
      assert safe_to_string(
        MockCell.container(%{}, closing_tag: false, data: [foo: "bar"])
      ) == "<div class=\"MockCell\" data-cell=\"MockCell\" data-cell-params=\"{}\" data-foo=\"bar\">"
    end
  end

  describe "class_name/0" do
    test "class_name()" do
      assert MockCell.class_name == "MockCell"
    end

    test "class_name() is overrideable" do
      assert MockCellWithOverridables.class_name == "Bar-MockCellWithOverridables"
    end
  end

  describe "attribute_name/0" do
    test "attribute_name()" do
      assert MockCell.attribute_name == "MockCell"
    end

    test "attribute_name() is overrideable" do
      assert MockCellWithOverridables.attribute_name == "World-MockCellWithOverridables"
    end
  end

  describe "params/0" do
    test "params()" do
      assert MockCell.params() == %{}
    end

    test "params() with overrideables" do
      assert MockCellWithOverridables.params() == %{foo: "Bar"}
    end
  end

  describe "params/1" do
    test "params(values)" do
      assert MockCell.params(%{ hello: "World" }) == %{hello: "World"}
    end

    test "params(values) with overrideables" do
      assert MockCellWithOverridables.params(%{hello: "World"})
        == %{foo: "Bar", hello: "World"}
    end
  end
end
