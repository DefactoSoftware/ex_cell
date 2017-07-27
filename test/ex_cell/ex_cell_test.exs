defmodule ExCell.Test do
  use ExUnit.Case

  import ExCell

  defmodule ExCell.Test.MockModule do

  end

  describe "module_relative_to/2" do
    test "removes the relative_to from the module names" do
      assert module_relative_to(ExCell.Test.MockModule, ExCell.Test) == ["MockModule"]
    end
  end
end
