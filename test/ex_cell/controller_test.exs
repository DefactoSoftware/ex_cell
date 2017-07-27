defmodule ExCell.ControllerTest do
  use ExUnit.Case

  defmodule MockController do
    use ExCell.Controller, adapter: MockController

    def render(conn, cell, template, args), do: [conn, cell, template, args]
  end

  test "cell/2 with ExCell" do
    assert MockController.cell(%{}, :mock_cell) === [%{}, :mock_cell, "template.html", []]
  end

  test "cell/3 with ExCell and arguments" do
    assert MockController.cell(%{}, :mock_cell, []) === [%{}, :mock_cell, "template.html", []]
  end
end
