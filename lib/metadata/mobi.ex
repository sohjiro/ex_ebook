defmodule ExEbook.Metadata.Mobi do
  @moduledoc """
  Module for handling metadata information for MOBI files
  """
  use ExEbook.Converter
  @line_delimiter "\n"
  @colon_delimiter ":"
  @command "mobitool"

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
    |> add_subject(information, "Subject")
    |> add_creator(information, "Publisher")
    |> add_language(information, "Language")
  end

  defp generate_map(line, metadata) do
    values = split_and_format_values(line)

    if length(values) === 2, do: apply(Map, :put, [metadata | values]), else: metadata
  end

  defp split_and_format_values(line) do
    line
    |> split_by(@colon_delimiter, parts: 2)
    |> Enum.map(&format_text/1)
  end

end
