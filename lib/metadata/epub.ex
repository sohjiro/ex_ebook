defmodule ExEbook.Metadata.Epub do
  @moduledoc """
  Module for handling metadata information for EPUB files
  """
  use ExEbook.Converter

  def read_file(path) do
    path
    |> ExEbook.Zip.open_file_in_memory()
    |> document_content()
  end

  def extract_metadata(data) do
    data
    |> ExEbook.Xml.read_document()
    |> ExEbook.Xml.find_elements('/package/metadata/dc:*')
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

  defp document_content({:ok, zip_pid}) do
    case ExEbook.Zip.read_in_memory_file(zip_pid, "content.opf") do
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
    |> ExEbook.Xml.find_elements('./text()')
    |> ExEbook.Xml.text()
  end

end
