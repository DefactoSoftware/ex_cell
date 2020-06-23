defmodule ExCell.Mixfile do
  use Mix.Project

  @version "0.0.15"

  def project do
    [
      app: :ex_cell,
      name: "ExCell",
      source_url: "https://github.com/defactosoftware/ex_cell",
      version: @version,
      elixir: "~> 1.2",
      elixirc_paths: elixirc_paths(Mix.env()),
      build_per_environment: false,
      description: description(),
      package: package(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test],
      dialyzer: [plt_add_deps: true]
    ]
  end

  def application do
    []
  end

  defp description do
    """
    A module for creating coupled modules of CSS, Javascript and Views in Phoenix.
    """
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(:dev), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [
      name: :ex_cell,
      maintainers: ["Jesse Dijkstra", "Matthijs Kuiper", "Marcel Horlings"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/defactosoftware/ex_cell"}
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev, :test]},
      {:ex_doc, ">= 0.0.0", only: [:dev, :test]},
      {:excoveralls, "~> 0.7", only: :test},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
      {:phoenix_html, "~> 2.14"},
      {:phoenix_live_view, "~> 0.13.3"},
      {:phoenix, "~> 1.4.17", optional: true},
      {:jason, "~> 1.1"},
      {:elixir_uuid, "~> 1.2"}
    ]
  end
end
