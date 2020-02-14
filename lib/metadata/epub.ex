defmodule ExEbook.Metadata.Epub do
  @moduledoc """
  Documentation for metadata element.
  """
  @behaviour ExEbook.Extracter
  @default_opts [{:namespace_conformant, true}, {:encoding, :latin1}]
  @comma_delimiter ","
  alias ExEbook.Metadata

  def read_file(path) do
    path
    |> to_charlist()
    |> open_file_in_memory()
    |> document_content()
  end

  def extract_metadata(data) do
    data
    |> parse_document()
    |> find_elements('/package/metadata/dc:*')
    |> to_map()
  end

  def transform(information) do
    %Metadata{}
    |> add_identifier(information) # isbn
    |> add_title(information)
    |> add_language(information)
    |> add_authors(information) # creator
    |> add_creator(information) # publisher
    |> add_subject(information)
  end

  defp add_identifier(metadata, information) do
    %{metadata | isbn: find_attribute(information, "identifier")}
  end

  defp add_title(metadata, information) do
    %{metadata | title: find_attribute(information, "title")}
  end

  defp add_language(metadata, information) do
    %{metadata | language: find_attribute(information, "language")}
  end

  defp add_authors(metadata, information) do
    %{metadata | authors: format_authors(information)}
  end

  defp add_creator(metadata, information) do
    %{metadata | publisher: find_attribute(information, "publisher")}
  end

  defp add_subject(metadata, information) do
    %{metadata | subject: find_attribute(information, "subject")}
  end

  defp format_authors(data) do
    case find_attribute(data, "creator") do
      nil ->
        nil

      author ->
        split_by(author, @comma_delimiter)
    end
  end

  defp open_file_in_memory(file),
    do: :zip.zip_open(file, [:memory])

  defp document_content({:ok, zip_pid}) do
    case :zip.zip_get('content.opf', zip_pid) do
      {:ok, {_filename, document}} ->
        {:ok, document}

      _error ->
        {:error, :epub_read}
    end
  end

  defp document_content(_), do: {:error, :invalid_type}

  defp parse_document(document) do
    document
    |> to_charlist()
    |> to_xml()
    |> elem(0)
  end

  defp to_xml(charlist), do: :xmerl_scan.string(charlist, @default_opts)

  defp find_elements(xml, path), do: :xmerl_xpath.string(path, xml)

  defp to_map(elements) do
    Enum.reduce(elements, %{}, fn(node, acc) ->
      Map.put(acc, key_name(node), node_text(node))
    end)
  end

  defp key_name(node) do
    node
    |> elem(3)
    |> elem(1)
    |> to_string()
  end

  defp node_text(node) do
    node
    |> find_elements('./text()')
    |> extract_text()
  end

  defp extract_text([]), do: nil

  defp extract_text([{_, _, _, _, text, _}]),
    do: :unicode.characters_to_binary(text, :latin1)

  defp find_attribute(data, attribute), do: Map.get(data, attribute, nil)

  defp split_by(text, delimiter, opts \\ []) do
    opts = Keyword.merge([trim: true], opts)
    String.split(text, delimiter, opts)
  end

end
