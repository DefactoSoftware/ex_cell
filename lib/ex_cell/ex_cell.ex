defmodule ExCell do
  @moduledoc false

  def module_relative_to(module, relative_to) do
    module
    |> Module.split
    |> Kernel.--(Module.split(relative_to))
  end

  def config(keyword, fallback \\ nil) do
    :ex_cell
    |> Application.get_env(__MODULE__, [])
    |> Keyword.get(keyword, fallback)
  end
end
