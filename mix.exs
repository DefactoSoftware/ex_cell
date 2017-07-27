defmodule ExCell.Mixfile do
  use Mix.Project

  @version "0.0.2"

  def project do
    [app: :ex_cell,
     name: "ExCell",
     source_url: "https://github.com/defactosoftware/ex_cell",
     version: @version,
     elixir: "~> 1.2",
     build_per_environment: false,
     description: description(),
     package: package(),
     deps: deps()]
  end

  def application do
    []
  end

  defp description do
  """
  A module for creating coupled modules of CSS, Javascript and Views in
  Phoenix.
  """
  end

  defp package do
    [
      name: :ex_cell,
      maintainers: ["Jesse Dijkstra"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/defactosoftware/ex_cell"}
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:phoenix_html, "~> 2.10"},
      {:poison, "~> 3.1"},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false}
    ]
  end
end
