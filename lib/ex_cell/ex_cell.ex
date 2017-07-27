defmodule ExCell do
  def module_relative_to(module, relative_to) do
    module
    |> Module.split
    |> Kernel.--(Module.split(relative_to))
  end
end
