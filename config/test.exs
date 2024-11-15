import Config

config :ex_cell, ExCell,
  view_adapter: ExCell.MockViewAdapter,
  controller_adapter: ExCell.MockControllerAdapter,
  foo: :bar
