defmodule ExEbook.MixProject do
  use Mix.Project

  @description """
    Metadata extracter for digital books (EPUB, MOBI, PDF)
  """

  def project do
    [
      app: :ex_ebook,
      version: "0.1.0",
      elixir: "~> 1.10",
      name: "ExEbook",
      description: @description,
      package: package(),
      deps: deps(),
      source_url: "https://github.com/sohjiro/ex_ebook",
      start_permanent: Mix.env() == :prod
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.3", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["Felipe Juarez Murillo"],
      licenses: ["MIT"],
      links: %{
        GitHub: "https://github.com/sohjiro/ex_ebook"
      }
    ]
  end
end
