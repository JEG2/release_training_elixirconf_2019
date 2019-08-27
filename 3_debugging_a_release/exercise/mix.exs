defmodule Exercise.MixProject do
  use Mix.Project

  def project do
    [
      app: :exercise,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :observer, :runtime_tools, :wx],
      mod: {Exercise.Application, []}
    ]
  end

  defp deps do
    [
      {:observer_cli, "~> 1.5"}
    ]
  end
end
