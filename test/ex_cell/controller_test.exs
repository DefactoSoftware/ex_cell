defmodule ExCell.ControllerTest do
  use ExUnit.Case

  test "cell/2 with ExCell" do
    assert ExCell.Controller.cell(%{}, :mock_cell) === [%{}, :mock_cell, "template.html", []]
  end

  test "cell/3 with ExCell and arguments" do
    assert ExCell.Controller.cell(%{}, :mock_cell, []) === [%{}, :mock_cell, "template.html", []]
  end
end
