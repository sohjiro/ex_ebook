defmodule ExEbookTest do
  use ExUnit.Case

  describe "Metadata correct extraction" do
    setup [:complete_metadata]

    test "should read metadata from a pdf file", %{path: path} do
      assert %ExEbook.Metadata{
        title: "No Silver Bullet ­ Essence and Accident in Software Engineering",
        authors: ["Frederick Brooks"],
        pages: "16",
        publisher: "Acrobat PDFMaker 5.0 for Word",
        language: nil,
        pages: "16",
        subject: nil,
        isbn: nil

      } == ExEbook.extract_metadata(path)
    end
  end

  describe "Metadata wrong extraction" do
    setup [:wrong_information]

    test "should not return an error when file is not a pdf", %{path: path} do
      assert {:error, :invalid_format} = ExEbook.extract_metadata(path)
    end
  end

  defp complete_metadata(context) do
    {:ok, Map.put(context, :path, "test/resources/Brooks-NoSilverBullet.pdf")}
  end

  defp wrong_information(context) do
    {:ok, Map.put(context, :path, "test/resources/something.txt")}
  end
end
