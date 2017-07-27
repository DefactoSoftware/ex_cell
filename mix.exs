defmodule ExCell.Mixfile do
  use Mix.Project

  @version "0.0.1"

  def project do
    [app: :ex_cell,
     name: "ExCell",
     version: @version,
     elixir: "~> 1.2",
     build_per_environment: false,
     description: description(),
     package: package(),
     deps: deps()]
  end

  def description do
  """
  A module for creating coupled modules of CSS, Javascript and Views in
  Phoenix.
  """
  end

  def package do
    [
      maintainers: ["Jesse Dijkstra"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/defactosoftware/ex_cell"}
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:phoenix_html, "~> 2.6"},
      {:poison, "~> 2.0"}
    ]
  end
end
