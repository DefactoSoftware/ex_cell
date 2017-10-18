defmodule ExCell.BaseTest do
  use ExUnit.Case

  alias ExCell.Base

  describe "relative_name/2" do
    test "returns the module name" do
      assert Base.relative_name(MockCell, nil) == "MockCell"
    end

    test "returns the relative module name" do
      assert Base.relative_name(Bar.MockCell, Bar) == "MockCell"
    end

    test "returns the relative module name with dashes for nested cells" do
      assert Base.relative_name(Bar.MockCell, nil) == "Bar-MockCell"
    end
  end

  describe "attributes/4" do
    test "it rejects nil values" do
      assert Base.attributes(nil, nil, [], %{}) ==
        [class: "", data: [cell: nil, cell_params: "{}"]]
    end

    test "it sets the data attribute" do
      assert Base.attributes(nil, nil, [data: [foo: "bar"]], %{}) ==
        [class: "", data: [foo: "bar", cell: nil, cell_params: "{}"]]
    end

    test "it sets the class attribute" do
      assert Base.attributes(nil, nil, [class: "foo"], %{}) ==
        [class: "foo", data: [cell: nil, cell_params: "{}"]]
    end
  end

  describe "data_attribute/3" do
    test "it defaults data to a list" do
      assert Base.data_attribute(nil, nil, %{}) == [cell: nil, cell_params: "{}"]
    end

    test "it sets the cell name" do
      assert Base.data_attribute("Hello", nil, %{}) ==
        [cell: "Hello", cell_params: "{}"]
    end

    test "it encodes params" do
      assert Base.data_attribute(nil, nil, %{foo: "Bar"}) ==
        [cell: nil, cell_params: "{\"foo\":\"Bar\"}"]
    end

    test "it adds data attributes" do
      assert Base.data_attribute(nil, [foo: "Bar"], %{}) ==
        [foo: "Bar", cell: nil, cell_params: "{}"]
    end
  end

  describe "class_attribute/2" do
    test "adds the name" do
      assert Base.class_attribute("Hello", "World") ==
        "Hello World"
    end

    test "allows lists" do
      assert Base.class_attribute(["Hello", "World"], ["Foo", "Bar"]) ==
        "Hello World Foo Bar"
    end

    test "rejects nil" do
      assert Base.class_attribute(nil, nil) == ""
    end
  end
end
