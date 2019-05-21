defmodule ExCell.LiveViewTest do
  use ExCell.ConnCase
  alias ExCell.LiveView

  test "live_cell/2 with ExCell", %{conn: conn} do
    assert LiveView.live_cell(:mock_cell, conn) === [conn, :mock_cell, [session: %{assigns: %{}}]]
  end

  test "live_cell/3 with assigns", %{conn: conn} do
    assert LiveView.live_cell(:mock_cell, conn, foo: "bar") === [
             conn,
             :mock_cell,
             [session: %{assigns: %{foo: "bar"}}]
           ]
  end

  test "live_cell/3 with do block", %{conn: conn} do
    assert LiveView.live_cell(:mock_cell, conn, do: "yes") === [
             conn,
             :mock_cell,
             [session: %{assigns: %{children: "yes"}}]
           ]
  end

  test "live_cell/3 with children", %{conn: conn} do
    assert LiveView.live_cell(:mock_cell, conn, "yes") === [
             conn,
             :mock_cell,
             [session: %{assigns: %{children: "yes"}}]
           ]
  end

  test "live_cell/3 with assign and do block", %{conn: conn} do
    assert LiveView.live_cell(:mock_cell, conn, [foo: "bar"], do: "yes") === [
             conn,
             :mock_cell,
             [session: %{assigns: %{children: "yes", foo: "bar"}}]
           ]
  end

  test "live_cell/3 with children and assign", %{conn: conn} do
    assert LiveView.live_cell(:mock_cell, conn, "yes", foo: "bar") === [
             conn,
             :mock_cell,
             [session: %{assigns: %{children: "yes", foo: "bar"}}]
           ]
  end
end
