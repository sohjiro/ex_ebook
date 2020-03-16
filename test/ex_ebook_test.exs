defmodule ExEbookTest do
  use ExUnit.Case

  describe "Metadata correct extraction" do
    setup [:complete_metadata]

    test "should read metadata from a pdf file", %{pdf: pdf_path} do
      assert %ExEbook.Metadata{
        title: "No Silver Bullet ­ Essence and Accident in Software Engineering",
        authors: ["Frederick Brooks"],
        pages: "16",
        publisher: "Acrobat PDFMaker 5.0 for Word",
        language: nil,
        subject: nil,
        isbn: nil,
        cover: :error
      } == ExEbook.extract_metadata(pdf_path)
    end

    test "should read metadata from an epub", %{epub: epub_path} do
      cover = File.read!("test/resources/programming-ecto_p1_0_cover.jpg")

      assert %ExEbook.Metadata{
        title: "Programming Ecto (for Felipe Juarez Murillo)",
        authors: ["Darin Wilson", "Eric Meadows-Jönsson"],
        pages: nil,
        publisher: "The Pragmatic Bookshelf, LLC (711823)",
        language: "en",
        subject: "Pragmatic Bookshelf",
        isbn: "978-1-68050-282-4",
        cover: cover
      } == ExEbook.extract_metadata(epub_path)
    end
  end

  describe "Metadata wrong extraction" do
    setup [:wrong_information]

    test "should not return an error when file is not a pdf", %{path: path} do
      assert {:error, :invalid_format} = ExEbook.extract_metadata(path)
    end
  end

  defp complete_metadata(context) do
    context =
      context
      |> Map.put(:pdf, "test/resources/Brooks-NoSilverBullet.pdf")
      |> Map.put(:epub, "test/resources/programming-ecto_p1_0.epub")

    {:ok, context}
  end

  defp wrong_information(context) do
    {:ok, Map.put(context, :path, "test/resources/something.txt")}
  end
end
