defmodule ExEbook.Converter do
  @moduledoc """
  Converter macro for extracting ebook information
  """

  defmacro __using__(_) do
    quote do
      @behaviour ExEbook.Extracter
      alias ExEbook.Metadata
      @comma_delimiter ","

      def process(file) do
        with {:ok, data} <- read_file(file) do
          data
          |> extract_metadata()
          |> transform()
        end
      end

      def to_map(enum, func) do
        Enum.reduce(enum, %{}, func)
      end

      defp add_identifier(metadata, information, key) do
        %{metadata | isbn: find_attribute(information, key)}
      end

      defp add_title(metadata, information, key) do
        %{metadata | title: find_attribute(information, key)}
      end

      defp add_language(metadata, information, key) do
        %{metadata | language: find_attribute(information, key)}
      end

      defp add_authors(metadata, information, key) do
        %{metadata | authors: format_authors(information, key)}
      end

      defp add_pages(metadata, information, key) do
        %{metadata | pages: find_attribute(information, key)}
      end

      defp add_creator(metadata, information, key) do
        %{metadata | publisher: find_attribute(information, key)}
      end

      defp add_subject(metadata, information, key) do
        %{metadata | subject: find_attribute(information, key)}
      end

      defp format_authors(data, key) do
        case find_attribute(data, key) do
          nil ->
            nil

          author ->
            split_by(author, @comma_delimiter)
        end
      end

      defp split_by(text, delimiter, opts \\ []) do
        opts = Keyword.merge([trim: true], opts)
        String.split(text, delimiter, opts)
      end

      defp format_text(text) do
        text
        |> String.trim()
        |> :unicode.characters_to_binary(:latin1)
      end

      defp find_attribute(data, attribute), do: Map.get(data, attribute, nil)

    end
  end
end
