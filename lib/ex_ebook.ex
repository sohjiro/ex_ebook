defmodule ExEbook do
  @moduledoc """
  Documentation for ExEbook Metadata metadata.
  """
  @pdf_formats ~w[.pdf .PDF]

  def extract_metadata(file) do
    file
    |> split()
    |> process()
  end

  defp split(file), do: {file, Path.extname(file)}

  defp process({file, extname}) when extname in @pdf_formats do
    ExEbook.Metadata.Pdf.process(file)
  end

  defp process(_), do: {:error, :invalid_format}

end
