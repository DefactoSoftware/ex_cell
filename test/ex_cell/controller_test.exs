defmodule ExCell.ControllerTest do
  use ExUnit.Case

  alias ExCell.Controller

  test "cell/1 without controller" do
    assert Controller.cell(:mock_cell) === [:mock_cell, "template.html", []]
  end

  test "cell/2 with controller" do
    assert Controller.cell(%Plug.Conn{private: %{}}, :mock_cell) === [
             %Plug.Conn{private: %{phoenix_view: :mock_cell}},
             "template.html",
             []
           ]
  end

  test "cell/2 without controller" do
    assert Controller.cell(:mock_cell, []) === [:mock_cell, "template.html", []]
  end

  test "cell/3 with controller and arguments" do
    assert Controller.cell(%Plug.Conn{private: %{}}, :mock_cell, []) === [
             %Plug.Conn{private: %{phoenix_view: :mock_cell}},
             "template.html",
             []
           ]
  end
end
