defmodule ExEbook.Metadata.Pdf do
  @moduledoc """
  Module for handling metadata information for PDF files
  """
  use ExEbook.Converter
  @line_delimiter "\n"
  @colon_delimiter ":"
  @command "pdfinfo"

  def read_file(path) do
    ExEbook.Shell.execute(@command, [path])
  end

  def extract_metadata(data) do
    data
    |> split_by(@line_delimiter)
    |> to_map(&generate_map/2)
  end

  def transform(information) do
    %Metadata{}
    |> add_title(information, "Title")
    |> add_authors(information, "Author")
    |> add_pages(information, "Pages")
    |> add_creator(information, "Creator")
  end

  defp generate_map(line, metadata) do
    values = split_and_format_values(line)
    apply(Map, :put, [metadata | values])
  end

  defp split_and_format_values(line) do
    line
    |> split_by(@colon_delimiter, parts: 2)
    |> Enum.map(&format_text(&1, decode: :latin1))
  end

end
