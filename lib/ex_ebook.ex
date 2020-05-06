defmodule ExEbook do
  @moduledoc """
  Documentation for ExEbook Metadata metadata.
  """
  @type path :: String.t()
  @type opts :: Keyword.t()
  @type metadata :: ExEbook.Metadata.t()

  @pdf ".pdf"
  @epub ".epub"
  @mobi ".mobi"

  @spec extract_metadata(path, opts) :: metadata()
  def extract_metadata(path, opts \\ []) do
    filename = Keyword.get(opts, :filename, path)

    path
    |> split(filename)
    |> process()
  end

  defp split(path, filename), do: {path, filename |> Path.extname() |> String.downcase()}

  defp process({file, @pdf}) do
    ExEbook.Metadata.Pdf.process(file)
  end

  defp process({file, @mobi}) do
    ExEbook.Metadata.Mobi.process(file)
  end

  defp process({file, @epub}) do
    ExEbook.Metadata.Epub.process(file)
  end

  defp process(_), do: {:error, :invalid_format}
end
