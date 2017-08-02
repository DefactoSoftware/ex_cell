defmodule ExCell.Cell do
  alias ExCell.Base
  alias ExCell.Cell

  use ExCell.Base

  @callback class_name() :: String.t
  @callback params() :: map

  @doc """
  Using macro
  """
  defmacro __using__(opts \\ []) do
    quote do
      use Base, unquote(opts)
      @behaviour Cell
    end
  end
end
