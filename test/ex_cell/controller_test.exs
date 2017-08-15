defmodule ExCell.ControllerTest do
  use ExUnit.Case

  test "cell/1 without controller" do
    assert ExCell.Controller.cell(:mock_cell) === [:mock_cell, "template.html", []]
  end

  test "cell/2 with controller" do
    assert ExCell.Controller.cell(%{}, :mock_cell) === [%{}, :mock_cell, "template.html", []]
  end

  test "cell/2 without controller" do
    assert ExCell.Controller.cell(:mock_cell, []) === [:mock_cell, "template.html", []]
  end

  test "cell/3 with controller and arguments" do
    assert ExCell.Controller.cell(%{}, :mock_cell, []) === [%{}, :mock_cell, "template.html", []]
  end
end
