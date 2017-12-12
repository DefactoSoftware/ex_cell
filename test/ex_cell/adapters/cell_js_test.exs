defmodule ExCell.Adapters.CellJSTest do
  use ExUnit.Case

  import Phoenix.HTML
  alias Phoenix.HTML.Tag

  alias ExCell.Adapters.CellJS

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
      attributes = %{
        name: "MockCell",
        attributes: [
          class: "MockCell"
        ],
        params: %{},
        content: nil
      }

      assert safe_to_string(CellJS.container(attributes))
        == "<div class=\"MockCell\" data-cell=\"MockCell\" data-cell-params=\"{}\"></div>"
    end

    test "custom tag" do
      attributes = %{
        name: "MockCell",
        attributes: [
          tag: :p,
          class: "MockCell"
        ],
        params: %{},
        content: nil
      }

      assert safe_to_string(CellJS.container(attributes))
        == "<p class=\"MockCell\" data-cell=\"MockCell\" data-cell-params=\"{}\"></p>"
    end

    test "auto closes void elements" do
      options = %{
        name: "MockCell",
        attributes: [
          class: "MockCell"
        ],
        params: %{},
        content: nil
      }

      Enum.each(CellJS.void_elements(), fn (void_element) ->
        void_element_options = Map.update!(
          options, :attributes, &Keyword.put(&1, :tag, void_element))

        assert safe_to_string(CellJS.container(void_element_options))
          == "<#{void_element} class=\"MockCell\" data-cell=\"MockCell\" data-cell-params=\"{}\">"
      end)
    end

    test "content" do
      attributes = %{
        name: "MockCell",
        attributes: [
          class: "MockCell"
        ],
        params: %{},
        content: "TestContent"
      }

      assert safe_to_string(CellJS.container(attributes))
        == "<div class=\"MockCell\" data-cell=\"MockCell\" data-cell-params=\"{}\">TestContent</div>"
    end

    test "unsafe content" do
      attributes = %{
        name: "MockCell",
        attributes: [
          class: "MockCell"
        ],
        params: %{},
        content: Tag.content_tag(:div, "TestContent")
      }

      assert safe_to_string(CellJS.container(attributes))
        == "<div class=\"MockCell\" data-cell=\"MockCell\" data-cell-params=\"{}\"><div>TestContent</div></div>"
    end

    test "cell params" do
      attributes = %{
        name: "MockCell",
        attributes: [
          class: "MockCell"
        ],
        params: %{
          foo: "bar"
        },
        content: nil
      }

      assert safe_to_string(CellJS.container(attributes))
        == "<div class=\"MockCell\" data-cell=\"MockCell\" data-cell-params=\"{&quot;foo&quot;:&quot;bar&quot;}\"></div>"
    end

    test "attributes" do
      attributes = %{
        name: "MockCell",
        attributes: [
          class: "MockCell",
          foo: "bar"
        ],
        params: %{},
        content: nil
      }

      assert safe_to_string(CellJS.container(attributes))
        == "<div class=\"MockCell\" data-cell=\"MockCell\" data-cell-params=\"{}\" foo=\"bar\"></div>"
    end

    test "data attributes" do
      attributes = %{
        name: "MockCell",
        attributes: [
          class: "MockCell",
          data: [foo: "bar"]
        ],
        params: %{},
        content: nil
      }

      assert safe_to_string(CellJS.container(attributes))
        == "<div class=\"MockCell\" data-cell=\"MockCell\" data-cell-params=\"{}\" data-foo=\"bar\"></div>"
    end
  end
end
