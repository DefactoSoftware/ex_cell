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
end
