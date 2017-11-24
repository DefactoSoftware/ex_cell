defmodule ExCellTest do
  use ExUnit.Case

  defmodule ExCellTest.MockModule do

  end

  describe "module_relative_to/2" do
    test "removes the relative_to from the module names" do
      assert ExCell.module_relative_to(ExCellTest.MockModule, ExCellTest) == ["MockModule"]
    end
  end

  describe "config/2" do
    test "fetches the value of the config" do
      assert ExCell.config(:foo) == :bar
    end

    test "returns nil without default" do
      assert ExCell.config(:hello) == nil
    end

    test "defaults to a value" do
      assert ExCell.config(:hello, :world) == :world
    end
  end

  describe "relative_name/2" do
    test "returns the module name" do
      assert ExCell.relative_name(MockCell, nil) == "MockCell"
    end

    test "returns the relative module name" do
      assert ExCell.relative_name(Bar.MockCell, Bar) == "MockCell"
    end

    test "returns the relative module name with dashes for nested cells" do
      assert ExCell.relative_name(Bar.MockCell, nil) == "Bar-MockCell"
    end
  end

  describe "class_name/2" do
    test "adds the name" do
      assert ExCell.class_name("Hello", "World") ==
        "Hello World"
    end

    test "allows lists" do
      assert ExCell.class_name(["Hello", "World"], ["Foo", "Bar"]) ==
        "Hello World Foo Bar"
    end

    test "rejects nil" do
      assert ExCell.class_name(nil, nil) == ""
    end
  end
end
