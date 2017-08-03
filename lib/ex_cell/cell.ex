defmodule ExCell.Cell do
  @moduledoc """
  Cells are used to tightly couple your templates, views and Javascript. It is
  heavily inspired by React by Facebook and Rails Cells by Trailblazer.
  """
  alias ExCell.Base
  alias ExCell.Cell

  use ExCell.Base

  @callback class_name() :: String.t
  @callback params() :: map

  @doc """
  Cells require you to use the __using__ macro to use them. This ensures that
  the cell namespaces are used.

  The cell allows you to override the class_name and params attributes.

  ## Options
  When you use the `__using__` macro you can specify a namespace it uses as its
  base to add the class and cells-js tags

  - `:namespace` - The base namespace it uses to base the `name` and `class_name` on

  ## Examples

      defmodule AppWeb.AvatarCell do
        use ExCell.Cell, namespace: AppWeb
      end

      iex(0)> AvatarCell.name
      "AvatarCell"

      defmodule AppWeb.AvatarCell do
        use ExCell.Cell
      end

      iex(0)> AvatarCell.name
      "AppWeb-AvatarCell"
  """
  defmacro __using__(opts \\ []) do
    quote do
      use Base, unquote(opts)
      @behaviour Cell
    end
  end
end
