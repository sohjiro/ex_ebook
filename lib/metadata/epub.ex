defmodule ExEbook.Metadata.Epub do
  @moduledoc """
  Module for handling metadata information for EPUB files
  """
  require Logger
  use ExEbook.Converter
  alias ExEbook.{Xml, Zip}
  @root_file "META-INF/container.xml"

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

  def extract_image(path) do
    with {:ok, zip_pid} <- Zip.open_file_in_memory(path),
         {:ok, document} <- open_root_file(zip_pid) do
      document
      |> Xml.read_document()
      |> fetch_cover(zip_pid)
    end
  end

  defp open_root_file(zip_pid) do
    case open_file(@root_file, zip_pid) do
      {:ok, document} ->
        document
        |> fetch_root_file_path()
        |> open_file(zip_pid)

      error ->
        Logger.error("EROR opening root file #{inspect error}")
        error
    end
  end

  defp fetch_root_file_path(document) do
    document
    |> Xml.read_document()
    |> from_document_extract_attrs('//rootfile/@full-path')
  end

  defp open_file(file_path, zip_pid) do
    case Zip.read_in_memory_file(zip_pid, file_path) do
      {:ok, document} ->
        {:ok, document}

      :error ->
        {:error, :epub_read}
    end
  end

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

  defp fetch_cover(document, zip_pid) do
    document
    |> find_item_name()
    |> find_item(document)
    |> open_file(zip_pid)
  end

  defp find_item_name(document) do
    from_document_extract_attrs(document, '//meta[@name="cover"]/@content')
  end

  defp find_item(item_name, document) do
    from_document_extract_attrs(document, '//manifest/item[@id="#{item_name}"]/@href')
  end

  defp from_document_extract_attrs(document, elements) do
    document
    |> Xml.find_elements(elements)
    |> Xml.extract_attr()
  end

end
