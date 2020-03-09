defmodule ExEbook.Metadata.Mobi do
  @moduledoc """
  Module for handling metadata information for MOBI files
  """
  use ExEbook.Converter
  require Logger

  alias ExEbook.Shell

  @line_delimiter "\n"
  @colon_delimiter ":"
  @command "mobitool"

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
    |> add_subject(information, "Subject")
    |> add_creator(information, "Publisher")
    |> add_language(information, "Language")
  end

  def extract_image(path) do
    case Shell.execute(@command, ["-o", Shell.current_tmp_dir(), "-s", path]) do
      {:ok, data} ->
        data
        |> markup_path()
        |> fetch_cover()

      error ->
        Logger.error("Extracting image from MOBI file #{inspect error}")
        :error
    end
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

  defp markup_path(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.find(&(String.starts_with?(&1, "Saving markup")))
    |> String.replace("Saving markup to ", "")
  end

  defp fetch_cover(dir_path) do
    try do
      dir_path
      |> find_opf_file()
      |> find_cover_file(dir_path)
      |> fetch_image(dir_path)
    rescue
      error in File.Error ->
        Logger.error("Error extracting image #{inspect error}")
        :error
    end
  end

  defp find_opf_file(dir_path) do
    dir_path
    |> File.ls!()
    |> Enum.find(&(String.ends_with?(&1, ".opf")))
  end

  defp find_cover_file(xml_file, dir_path) do
    dir_path
    |> Path.join(xml_file)
    |> File.read!()
    |> ExEbook.Xml.read_document()
    |> ExEbook.Xml.find_elements('//meta[@name="cover"]/@content')
    |> ExEbook.Xml.extract_attr()
  end

  defp fetch_image(cover_file, dir_path) do
    dir_path
    |> File.ls!()
    |> Enum.find(&(String.starts_with?(&1, cover_file)))
    |> to_absolute_path(dir_path)
    |> File.read!()
  end

  defp to_absolute_path(name, dir_path) do
    Path.join(dir_path, name)
  end

end
