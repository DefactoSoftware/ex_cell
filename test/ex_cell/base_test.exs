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
