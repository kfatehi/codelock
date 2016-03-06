defmodule Codelock.Mixfile do
  use Mix.Project

  def project do
    [app: :codelock,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger, :elixir_ale, :ethernet, :poison, :plug, :cowboy, :corsica],
     mod: {Codelock, {}}]
  end

  defp deps do
    [
      { :exrm, "~> 0.15.0" },
      { :elixir_ale, "~> 0.4.0" },
      { :ethernet, git: "https://github.com/cellulose/ethernet.git" },
      { :cowboy, "~> 1.0.4" },
      { :plug, "~> 1.1.2" },
      { :poison, "~> 1.5" },
      { :corsica, "~> 0.4" }
    ]
  end
end
