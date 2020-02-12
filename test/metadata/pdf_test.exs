defmodule ExEbook.Metadata.PdfTest do
  use ExUnit.Case
  alias ExEbook.Metadata.Pdf

  describe "Metadata correct extraction" do
    setup [:complete_metadata]

    test "should read a pdf file", %{path: path} do
      assert Pdf.read_file(path)
    end

    test "should extract metadata from file", %{path: path} do
      data = Pdf.read_file(path)
      assert Pdf.extract_metadata(data) == expected_metadata()
    end

    test "should transform metadata into a struct", %{path: path} do
      metadata =
        path
        |> Pdf.read_file()
        |> Pdf.extract_metadata()
        |> Pdf.transform()

      assert %ExEbook.Metadata{
        title: "No Silver Bullet ­ Essence and Accident in Software Engineering",
        authors: ["Frederick Brooks"],
        pages: "16",
        page_size: "612 x 792 pts (letter) (rotated 0 degrees)",
        file_size: "266288",
        creator: "Acrobat PDFMaker 5.0 for Word",
      } = metadata
    end
  end

  describe "Metadata wrong extraction" do
    setup [:wrong_information]

    test "should return an error tuple when file is not valid", %{path: path} do
      assert {:error, :invalid_type} = Pdf.read_file(path)
    end
  end

  defp complete_metadata(context) do
    {:ok, Map.put(context, :path, "test/resources/Brooks-NoSilverBullet.pdf")}
  end

  defp wrong_information(context) do
    {:ok, Map.put(context, :path, "test/resources/something.pdf")}
  end

  defp expected_metadata do
    %{
      "Title" => "No Silver Bullet ­ Essence and Accident in Software Engineering",
      "Author" => "Frederick Brooks",
      "Creator" => "Acrobat PDFMaker 5.0 for Word",
      "Producer" => "Acrobat Distiller 5.0 (Windows)",
      "CreationDate" => "Thu Jul 18 23:38:45 2002",
      "ModDate" => "Tue Jul 23 07:29:27 2002",
      "Tagged" => "yes",
      "Form" => "none",
      "Pages" => "16",
      "Encrypted" => "yes (print:yes copy:no change:no addNotes:no)",
      "Page size" => "612 x 792 pts (letter) (rotated 0 degrees)",
      "File size" => "266288 bytes",
      "Optimized" => "yes",
      "PDF version" => "1.4"
    }
  end
end
