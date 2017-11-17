defmodule ExCell.Adapter do
  @callback container(Map.t, List.t, term) :: {:safe, List.t}
end
