defmodule ExEbook.Metadata.Pdf do
  @moduledoc """
  Documentation for metadata element.
  """
  @behaviour ExEbook.Metadata
  alias ExEbook.Metadata

  @line_delimiter "\n"
  @colon_delimiter ":"
  @comma_delimiter ","
  @space_delimite " "

  def process(file) do
    with {:ok, data} <- read_file(file) do
      data
      |> extract_metadata()
      |> transform()
    end
  end

  def read_file(path) do
    case System.cmd("pdfinfo", [path]) do
      {data, 0} ->
        {:ok, data}

      _other ->
        {:error, :invalid_type}
    end
  end

  def extract_metadata(data) do
    data
    |> split_by(@line_delimiter)
    |> Enum.reduce(%{}, &to_map/2)
  end

  def transform(information) do
    %Metadata{}
    |> add_title(information)
    |> add_authors(information)
    |> add_pages(information)
    |> add_page_size(information)
    |> add_file_size(information)
    |> add_creator(information)
  end

  defp add_title(metadata, information) do
    %{metadata | title: find_attribute(information, "Title")}
  end

  defp add_authors(metadata, information) do
    %{metadata | authors: format_authors(information)}
  end

  defp add_pages(metadata, information) do
    %{metadata | pages: find_attribute(information, "Pages")}
  end

  defp add_page_size(metadata, information) do
    %{metadata | page_size: find_attribute(information, "Page size")}
  end

  defp add_file_size(metadata, information) do
    %{metadata | file_size: format_size(information)}
  end

  defp add_creator(metadata, information) do
    %{metadata | creator: find_attribute(information, "Creator")}
  end

  defp to_map(line, metadata) do
    values = split_and_format_values(line)
    apply(Map, :put, [metadata | values])
  end

  defp split_and_format_values(line) do
    line
    |> split_by(@colon_delimiter, parts: 2)
    |> Enum.map(&format_text/1)
  end

  defp format_text(text) do
    text
    |> String.trim()
    |> :unicode.characters_to_binary(:latin1)
  end

  defp format_authors(data) do
    case find_attribute(data, "Author") do
      nil ->
        nil

      author ->
        split_by(author, @comma_delimiter)
    end
  end

  defp format_size(data) do
    data
    |> find_attribute("File size")
    |> split_by(@space_delimite)
    |> Enum.at(0)
  end

  defp split_by(text, delimiter, opts \\ []) do
    opts = Keyword.merge([trim: true], opts)
    String.split(text, delimiter, opts)
  end

  defp find_attribute(data, attribute), do: Map.get(data, attribute, nil)

end
