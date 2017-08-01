defmodule ExCell.ViewTest do
  use ExUnit.Case
  alias ExCell.View
  alias ExCell.Test.MockViewAdapter

  defmodule MockCell do
    @moduledoc """
    Mock Test ExCell that defines the adapter
    """
    def view_adapter, do: MockViewAdapter
  end

  test "cell/1 with ExCell" do
    assert View.cell(MockCell) === [MockCell, "template.html", []]
  end

  test "cell/2 with assigns" do
    assert View.cell(MockCell, [foo: "bar"]) === [
      MockCell,
      "template.html",
      [foo: "bar"]
    ]
  end

  test "cell/2 with do block" do
    assert View.cell(MockCell, [do: "yes"]) === [
      MockCell,
      "template.html",
      [children: "yes"]
    ]
  end

  test "cell/2 with children" do
    assert View.cell(MockCell, "yes") === [
      MockCell,
      "template.html",
      [children: "yes"]
    ]
  end

  test "cell/2 with assign and do block" do
    assert View.cell(MockCell, [foo: "bar"], [do: "yes"]) === [
      MockCell,
      "template.html",
      [children: "yes", foo: "bar"]
    ]
  end

  test "cell/2 with children and assign" do
    assert View.cell(MockCell, "yes", foo: "bar") === [
      MockCell,
      "template.html",
      [children: "yes", foo: "bar"]
    ]
  end

  test "cell_to_string/1 with ExCell" do
    assert View.cell_to_string(MockCell) === [MockCell, "template.html", []]
  end

  test "cell_to_string/2 with assigns" do
    assert View.cell_to_string(MockCell, foo: "bar") === [
      MockCell,
      "template.html",
      [foo: "bar"]
    ]
  end

  test "cell_to_string/2 with do block" do
    assert View.cell_to_string(MockCell, [do: "yes"]) === [
      MockCell,
      "template.html",
      [children: "yes"]
    ]
  end

  test "cell_to_string/2 with assign and do block" do
    assert View.cell_to_string(MockCell, [foo: "bar"], [do: "yes"]) === [
      MockCell,
      "template.html",
      [children: "yes", foo: "bar"]
    ]
  end
end
