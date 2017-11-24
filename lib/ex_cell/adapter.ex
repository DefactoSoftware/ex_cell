defmodule ExCell.Adapter do
  @moduledoc false
  @callback container(Map.t) :: {:safe, List.t}
end
