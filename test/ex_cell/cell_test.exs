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
    def cell_name, do: "World-" <> name()
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

  describe "cell_name/0" do
    test "cell_name()" do
      assert MockCell.cell_name == "MockCell"
    end

    test "cell_name() is overrideable" do
      assert MockCellWithOverridables.cell_name == "World-MockCellWithOverridables"
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

  describe "adapter_options/3" do
    test "without arguments" do
      assert MockCell.adapter_options() == %{
        name: "MockCell",
        attributes: [
          class: "MockCell"
        ],
        closing_tag: true,
        content: nil,
        params: %{},
        tag: :div
      }
    end

    test "with overrideables" do
      assert MockCellWithOverridables.adapter_options() == %{
        name: "World-MockCellWithOverridables",
        attributes: [
          class: "Bar-MockCellWithOverridables"
        ],
        closing_tag: true,
        content: nil,
        params: %{
          foo: "Bar"
        },
        tag: :div
      }
    end

    test "with custom tag" do
      assert MockCell.adapter_options(%{}, tag: :p) == %{
        name: "MockCell",
        attributes: [
          class: "MockCell"
        ],
        closing_tag: true,
        content: nil,
        params: %{},
        tag: :p
      }
    end

    test "with content" do
      assert MockCell.adapter_options(%{}, [], "TestContent") == %{
        name: "MockCell",
        attributes: [
          class: "MockCell"
        ],
        closing_tag: true,
        content: "TestContent",
        params: %{},
        tag: :div
      }
    end

    test "with cell params" do
      assert MockCell.adapter_options(%{ foo: "bar" }) == %{
        name: "MockCell",
        attributes: [
          class: "MockCell"
        ],
        closing_tag: true,
        content: nil,
        params: %{
          foo: "bar"
        },
        tag: :div
      }
    end

    test "with custom atttributes" do
      assert MockCell.adapter_options(%{}, foo: "bar") == %{
        name: "MockCell",
        attributes: [
          class: "MockCell",
          foo: "bar"
        ],
        closing_tag: true,
        content: nil,
        params: %{},
        tag: :div
      }
    end

    test "without closing tag" do
      assert MockCell.adapter_options(%{}, closing_tag: false) == %{
        name: "MockCell",
        attributes: [
          class: "MockCell"
        ],
        closing_tag: false,
        content: nil,
        params: %{},
        tag: :div
      }
    end
  end
end
