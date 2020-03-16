defmodule ExEbook.Converter do
  @moduledoc """
  Converter macro for extracting ebook information
  """

  defmacro __using__(_) do
    quote do
      @behaviour ExEbook.Extracter
      alias ExEbook.Metadata
      @comma_delimiter ","
      @semicolon_delimiter ";"

      def process(file) do
        with {:ok, data} <- read_file(file) do
          data
          |> extract_metadata()
          |> transform()
          |> add_image(file)
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

      defp add_image(metadata, file) do
        case extract_image(file) do
          {:ok, file} ->
            %{metadata | cover: file}

          _error ->
            %{metadata | cover: :error}
        end
      end

      defp format_authors(data, key) do
        case find_attribute(data, key) do
          nil ->
            nil

          author ->
            author
            |> split_by([@comma_delimiter, @semicolon_delimiter])
            |> Enum.map(&String.trim/1)
        end
      end

      defp split_by(text, delimiter, opts \\ []) do
        opts = Keyword.merge([trim: true], opts)
        String.split(text, delimiter, opts)
      end

      defp format_text(text, opts \\ []) do
        text = String.trim(text)

        case Keyword.fetch(opts, :decode) do
          {:ok, format} ->
            :unicode.characters_to_binary(text, format)

          _ ->
            text
        end
      end

      defp find_attribute(data, attribute), do: Map.get(data, attribute, nil)

    end
  end
end
