defmodule ExCell.Adapter do
  @callback container(Map.t) :: {:safe, List.t}
end
