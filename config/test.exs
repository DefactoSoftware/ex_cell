use Mix.Config

config :ex_cell, ExCell, view_adapter: ExCell.MockViewAdapter,
                         controller_adapter: ExCell.MockControllerAdapter,
                         cell_adapter: ExCell.MockCellAdapter
