defmodule ExCell do
  @moduledoc """
  Generic ExCell methods
  """
  def module_relative_to(module, relative_to) do
    module
    |> Module.split
    |> Kernel.--(Module.split(relative_to))
  end

  def config(keyword, fallback \\ nil) do
    Application.fetch_env!(:ex_cell, __MODULE__)
    |> Keyword.get(keyword, fallback)
  end
end
