defmodule ExCell.Adapters.CellJSTest do
  use ExUnit.Case

  import Phoenix.HTML
  alias Phoenix.HTML.Tag

  alias ExCell.Cell
  alias ExCell.Adapters.CellJS

  defmodule MockCell do
    use Cell, namespace: ExCell.Adapters.CellJSTest
  end

  describe "attributes/3" do
    test "it rejects nil values" do
      assert CellJS.attributes(nil, [], %{}) ==
        [data: [cell: nil, cell_params: "{}"]]
    end

    test "it sets the data attribute" do
      assert CellJS.attributes(nil, [data: [foo: "bar"]], %{}) ==
        [data: [foo: "bar", cell: nil, cell_params: "{}"]]
    end

    test "it sets the class attribute" do
      assert CellJS.attributes(nil, [class: "foo"], %{}) ==
        [data: [cell: nil, cell_params: "{}"], class: "foo"]
    end
  end

  describe "data_attribute/3" do
    test "it defaults" do
      assert CellJS.data_attribute(nil) == [cell: nil, cell_params: "{}"]
    end

    test "it defaults data to a list" do
      assert CellJS.data_attribute(nil, nil, %{}) == [cell: nil, cell_params: "{}"]
    end

    test "it sets the cell name" do
      assert CellJS.data_attribute("Hello", nil, %{}) ==
        [cell: "Hello", cell_params: "{}"]
    end

    test "it encodes params" do
      assert CellJS.data_attribute(nil, nil, %{foo: "Bar"}) ==
        [cell: nil, cell_params: "{\"foo\":\"Bar\"}"]
    end

    test "it adds data attributes" do
      assert CellJS.data_attribute(nil, [foo: "Bar"], %{}) ==
        [foo: "Bar", cell: nil, cell_params: "{}"]
    end
  end

  describe "container/1" do
    test "defaults to a :div as tag" do
      assert safe_to_string(CellJS.container(MockCell.adapter_options()))
        == "<div class=\"MockCell\" data-cell=\"MockCell\" data-cell-params=\"{}\"></div>"
    end

    test "custom tag" do
      assert safe_to_string(CellJS.container(MockCell.adapter_options(%{}, tag: :p)))
        == "<p class=\"MockCell\" data-cell=\"MockCell\" data-cell-params=\"{}\"></p>"
    end

    test "content" do
      assert safe_to_string(CellJS.container(MockCell.adapter_options(%{}, [], "TestContent")))
        == "<div class=\"MockCell\" data-cell=\"MockCell\" data-cell-params=\"{}\">TestContent</div>"
    end

    test "unsafe content" do
      assert safe_to_string(
        CellJS.container(MockCell.adapter_options(%{}, [], Tag.content_tag(:div, "TestContent")))
      ) == "<div class=\"MockCell\" data-cell=\"MockCell\" data-cell-params=\"{}\"><div>TestContent</div></div>"
    end

    test "cell params" do
      assert safe_to_string(
        CellJS.container(MockCell.adapter_options(%{ foo: "bar" }))
      ) == "<div class=\"MockCell\" data-cell=\"MockCell\" data-cell-params=\"{&quot;foo&quot;:&quot;bar&quot;}\"></div>"
    end

    test "attributes" do
      assert safe_to_string(
        CellJS.container(MockCell.adapter_options(%{}, foo: "bar"))
      ) == "<div class=\"MockCell\" data-cell=\"MockCell\" data-cell-params=\"{}\" foo=\"bar\"></div>"
    end

    test "data attributes" do
      assert safe_to_string(
        CellJS.container(MockCell.adapter_options(%{}, data: [foo: "bar"]))
      ) == "<div class=\"MockCell\" data-cell=\"MockCell\" data-cell-params=\"{}\" data-foo=\"bar\"></div>"
    end

    test "no closing tag" do
      assert safe_to_string(
        CellJS.container(MockCell.adapter_options(%{}, closing_tag: false, data: [foo: "bar"]))
      ) == "<div class=\"MockCell\" data-cell=\"MockCell\" data-cell-params=\"{}\" data-foo=\"bar\">"
    end
  end
end
