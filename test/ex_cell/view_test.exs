defmodule ExCell.ViewTest do
  use ExUnit.Case
  alias ExCell.View

  test "relative_path/2" do
    assert View.relative_path(ExCell.Test.MockViewAdapterCell, ExCell) == "test/mock_view_adapter"
  end

  test "cell/1 with ExCell" do
    assert View.cell(:mock_cell) === [:mock_cell, "template.html", []]
  end

  test "cell/2 with assigns" do
    assert View.cell(:mock_cell, [foo: "bar"]) === [
      :mock_cell,
      "template.html",
      [foo: "bar"]
    ]
  end

  test "cell/2 with do block" do
    assert View.cell(:mock_cell, [do: "yes"]) === [
      :mock_cell,
      "template.html",
      [children: "yes"]
    ]
  end

  test "cell/2 with children" do
    assert View.cell(:mock_cell, "yes") === [
      :mock_cell,
      "template.html",
      [children: "yes"]
    ]
  end

  test "cell/2 with assign and do block" do
    assert View.cell(:mock_cell, [foo: "bar"], [do: "yes"]) === [
      :mock_cell,
      "template.html",
      [children: "yes", foo: "bar"]
    ]
  end

  test "cell/2 with children and assign" do
    assert View.cell(:mock_cell, "yes", foo: "bar") === [
      :mock_cell,
      "template.html",
      [children: "yes", foo: "bar"]
    ]
  end

  test "cell_to_string/1 with ExCell" do
    assert View.cell_to_string(:mock_cell) === [:mock_cell, "template.html", []]
  end

  test "cell_to_string/2 with assigns" do
    assert View.cell_to_string(:mock_cell, foo: "bar") === [
      :mock_cell,
      "template.html",
      [foo: "bar"]
    ]
  end

  test "cell_to_string/2 with do block" do
    assert View.cell_to_string(:mock_cell, [do: "yes"]) === [
      :mock_cell,
      "template.html",
      [children: "yes"]
    ]
  end

  test "cell_to_string/2 with assign and do block" do
    assert View.cell_to_string(:mock_cell, [foo: "bar"], [do: "yes"]) === [
      :mock_cell,
      "template.html",
      [children: "yes", foo: "bar"]
    ]
  end
end
