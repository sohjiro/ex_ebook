defmodule ExEbook.Metadata.Pdf do
  @moduledoc """
  Module for handling metadata information for PDF files
  """
  use ExEbook.Converter
  alias ExEbook.Shell
  require Logger

  @line_delimiter "\n"
  @colon_delimiter ":"
  @command "pdfinfo"
  @image_command "pdfimages"

  def read_file(path) do
    Shell.execute(@command, [path])
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

  def extract_image(path) do
    case Shell.execute(@image_command, [
           "-f",
           "0",
           "-l",
           "1",
           "-j",
           "-list",
           path,
           Shell.current_tmp_dir()
         ]) do
      {:ok, paths} ->
        paths
        |> extract_path()
        |> File.read()

      error ->
        Logger.error("#{inspect(error)}")
        {:error, :unsupported_operation}
    end
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

  defp extract_path(paths) do
    paths
    |> split_and_trim("\n")
    |> get_path()
  end

  defp get_path([path | _]) do
    path
    |> split_and_trim(":")
    |> Enum.at(0)
  end

  defp split_and_trim(string, pattern) do
    String.split(string, pattern, trim: true)
  end
end
