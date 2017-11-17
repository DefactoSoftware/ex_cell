defmodule ExCell.CellTest do
  use ExUnit.Case
  alias ExCell.Cell

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
