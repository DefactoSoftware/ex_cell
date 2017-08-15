defmodule ExCell.Mixfile do
  use Mix.Project

  @version "0.0.7"

  def project do
    [app: :ex_cell,
     name: "ExCell",
     source_url: "https://github.com/defactosoftware/ex_cell",
     version: @version,
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
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

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(:dev), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

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
      {:ex_doc, ">= 0.0.0", only: [:dev, :test]},
      {:phoenix_html, "~> 2.10"},
      {:poison, "~> 3.1"},
      {:mix_test_watch, "~> 0.3", only: :dev, runtime: false},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false}
    ]
  end
end
