defmodule ExCell.CellTest do
  use ExUnit.Case
  alias ExCell.Cell

  defmodule MockAdapter do
    def container(options), do: options
    def container(options, callback), do: Map.put(options, :content, callback.())
  end

  defmodule Foo.MockCell do
    use Cell,
      namespace: Foo,
      adapter: MockAdapter
  end

  defmodule Foo.Bar.MockCell do
    use Cell,
      namespace: Foo,
      adapter: MockAdapter
  end

  defmodule Foo.MockCellWithOverridables do
    use Cell,
      namespace: Foo,
      adapter: MockAdapter

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
      assert MockCell.class_name() == "MockCell"
    end

    test "class_name() is overrideable" do
      assert MockCellWithOverridables.class_name() == "Bar-MockCellWithOverridables"
    end
  end

  describe "cell_name/0" do
    test "cell_name()" do
      assert MockCell.cell_name() == "MockCell"
    end

    test "cell_name() is overrideable" do
      assert MockCellWithOverridables.cell_name() == "World-MockCellWithOverridables"
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
      assert MockCell.params(%{hello: "World"}) == %{hello: "World"}
    end

    test "params(values) with overrideables" do
      assert MockCellWithOverridables.params(%{hello: "World"}) == %{foo: "Bar", hello: "World"}
    end
  end

  describe "container/3" do
    test "without arguments" do
      assert %{
               name: "MockCell",
               attributes: [
                 class: "MockCell"
               ],
               content: nil,
               params: %{},
               id: _id
             } = MockCell.container()
    end

    test "with overrideables" do
      assert %{
               name: "World-MockCellWithOverridables",
               attributes: [
                 class: "Bar-MockCellWithOverridables"
               ],
               content: "TestContent",
               params: %{
                 foo: "Bar"
               },
               id: _id
             } = MockCellWithOverridables.container(%{}, [], do: "TestContent")
    end

    test "with content" do
      assert %{
               name: "MockCell",
               attributes: [
                 class: "MockCell"
               ],
               content: "TestContent",
               params: %{},
               id: _id
             } = MockCell.container(%{}, [], do: "TestContent")
    end

    test "with cell params" do
      assert %{
               name: "MockCell",
               attributes: [
                 class: "MockCell"
               ],
               content: nil,
               params: %{
                 foo: "bar"
               },
               id: _id
             } = MockCell.container(%{foo: "bar"})
    end

    test "with custom atttributes" do
      assert %{
               name: "MockCell",
               attributes: [
                 class: "MockCell",
                 foo: "bar"
               ],
               content: nil,
               params: %{},
               id: _id
             } = MockCell.container(%{}, foo: "bar")
    end

    test "with function" do
      assert %{
               name: "MockCell",
               attributes: [
                 class: "MockCell"
               ],
               content: "Hello",
               params: %{},
               id: _id
             } = MockCell.container(fn -> "Hello" end)
    end
  end
end
