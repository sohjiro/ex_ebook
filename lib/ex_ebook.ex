defmodule ExEbook do
  @moduledoc """
  Documentation for ExEbook Metadata metadata.
  """
  @pdf ".pdf"
  @epub ".epub"

  def extract_metadata(file) do
    file
    |> split()
    |> process()
  end

  defp split(file), do: {file, file |> Path.extname() |> String.downcase()}

  defp process({file, @pdf}) do
    ExEbook.Metadata.Pdf.process(file)
  end

  defp process(_), do: {:error, :invalid_format}

end
