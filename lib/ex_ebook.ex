defmodule ExEbook do
  @moduledoc """
  Documentation for ExEbook Metadata metadata.
  """
  @type path :: String.t()
  @type metadata :: ExEbook.Metadata.t()

  @pdf ".pdf"
  @epub ".epub"
  @mobi ".mobi"

  @spec extract_metadata(path) :: metadata()
  def extract_metadata(file) do
    file
    |> split()
    |> process()
  end

  defp split(file), do: {file, file |> Path.extname() |> String.downcase()}

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
