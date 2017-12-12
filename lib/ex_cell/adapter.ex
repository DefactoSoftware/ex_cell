defmodule ExCell.Adapter do
  @moduledoc """
  An ExCell Adapter defines the way the adapter outputs its HTML. The adapter
  requires a function called adapter that accepts a map container name,
  attributes, params and the content. It should return a Phoenix.HTML safe string.
  """

  @type html :: {:safe, list()}

  @type options :: %{
    required(:name) => String.t,
    required(:attributes) => list(),
    required(:params) => map(),
    required(:content) => String.t | {:safe, list()}
  }

  @callback container(options :: options()) :: html()
end
