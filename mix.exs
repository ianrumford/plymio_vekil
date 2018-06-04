defmodule Plymio.Vekil.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :plymio_vekil,
      version: @version,
      description: description(),
      package: package(),
      source_url: "https://github.com/ianrumford/plymio_vekil",
      homepage_url: "https://github.com/ianrumford/plymio_vekil",
      docs: [extras: ["./README.md", "./CHANGELOG.md"]],
      elixir: "~> 1.6",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:harnais_helper, "~> 0.1.0", only: :test},
      {:plymio_funcio, "~> 0.2.0"},
      {:ex_doc, "~> 0.18.3", only: :dev}
    ]
  end

  defp package do
    [
      maintainers: ["Ian Rumford"],
      files: ["lib", "mix.exs", "README*", "LICENSE*", "CHANGELOG*"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/ianrumford/plymio_vekil"}
    ]
  end

  defp description do
    """
    plymio_vekil: A vekil is a collection that associates proxies with foroms.
    """
  end
end
