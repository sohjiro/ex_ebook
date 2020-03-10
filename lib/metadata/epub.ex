defmodule ExEbook.Metadata.Epub do
  @moduledoc """
  Module for handling metadata information for EPUB files
  """
  use ExEbook.Converter
  alias ExEbook.{Xml, Zip}

  def read_file(path) do
    case Zip.open_file_in_memory(path) do
      {:ok, zip_pid} ->
        open_root_file(zip_pid)

      _ ->
        {:error, :invalid_type}
    end
  end

  def extract_metadata(data) do
    data
    |> Xml.read_document()
    |> Xml.find_elements('/package/metadata/dc:*')
    |> to_map(&generate_map/2)
  end

  def transform(information) do
    %Metadata{}
    |> add_identifier(information, "identifier") # isbn
    |> add_title(information, "title")
    |> add_language(information, "language")
    |> add_authors(information, "creator") # creator
    |> add_creator(information, "publisher") # publisher
    |> add_subject(information, "subject")
  end

  defp open_root_file(zip_pid) do
    case Zip.read_in_memory_file(zip_pid, "META-INF/container.xml") do
      {:ok, document} ->
        document
        |> fetch_root_file_path()
        |> read_document(zip_pid)

      _ ->
        {:error, :container_not_found}
    end
  end

  defp fetch_root_file_path(document) do
    document
    |> Xml.read_document()
    |> Xml.find_elements('//rootfile/@full-path')
    |> Xml.extract_attr()
  end

  defp read_document(file_path, zip_pid) do
    case Zip.read_in_memory_file(zip_pid, file_path) do
      {:ok, document} ->
        {:ok, document}

      :error ->
        {:error, :epub_read}
    end
  end

  defp document_content(_), do: {:error, :invalid_type}

  defp generate_map(node, map) do
    Map.put(map, key_name(node), node_text(node))
  end

  defp key_name(node) do
    node
    |> elem(3)
    |> elem(1)
    |> to_string()
  end

  defp node_text(node) do
    node
    |> Xml.find_elements('./text()')
    |> Xml.text()
  end

end
