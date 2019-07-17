defmodule DieScheiteWebApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :die_scheite_web_api,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: compiler_paths(Mix.env())
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {DieScheiteWebApi, []}
    ]
  end

  defp compiler_paths(:test), do: ["test/helpers"] ++ compiler_paths(:prod)
  defp compiler_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:confex, "~> 3.4.0"},
      {:distillery, "~> 2.1.0", runtime: false},
      {:ex_json_schema, "~> 0.6.1"},
      {:jason, "~> 1.1.0"},
      {:plug, "~> 1.7"},
      {:plug_cowboy, "~> 2.0"},
      {:uuid, "~> 1.1"}
    ]
  end
end
