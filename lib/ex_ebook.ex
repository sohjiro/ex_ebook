defmodule ExEbook do
  @moduledoc """
  Documentation for ExEbook Metadata metadata.
  """
  @formats ~w[.pdf .PDF]

  def extract_metadata(file) do
    case validate_format(file) do
      :ok ->
        "pdfinfo"
        |> System.cmd([file])
        |> ExEbook.Metadata.new()
      :error ->
        {:error, :invalid_format}
    end
  end

  defp extract_metadata_from(file) do
    case System.cmd("pdfinfo", [file]) do
      {data, 0} ->
        data

      _other ->
        {:error, :incorrect_file}
    end
  end

  defp validate_format(file) do
    if Path.extname(file) in @formats, do: :ok, else: :error
  end
end
