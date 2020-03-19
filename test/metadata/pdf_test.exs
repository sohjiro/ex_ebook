defmodule ExEbook.Metadata.PdfTest do
  use ExUnit.Case
  alias ExEbook.Metadata.Pdf

  describe "Metadata correct extraction" do
    setup [:complete_metadata]

    test "should read a pdf file", %{path: path} do
      assert {:ok, _} = Pdf.read_file(path)
    end

    test "should extract metadata from file", %{path: path} do
      {:ok, data} = Pdf.read_file(path)
      assert Pdf.extract_metadata(data) == expected_metadata()
    end

    test "should transform metadata into a struct", %{path: path} do
      {:ok, data} = Pdf.read_file(path)

      metadata =
        data
        |> Pdf.extract_metadata()
        |> Pdf.transform()

      assert %ExEbook.Metadata{
               title: "No Silver Bullet ­ Essence and Accident in Software Engineering",
               authors: ["Frederick Brooks"],
               pages: "16"
             } = metadata
    end

    test "should extract image from a pdf file" do
      path = "test/resources/stuff_goes_bad_erlang_in_anger.pdf"
      cover = File.read("test/resources/stuff_goes_bad_erlang_in_anger.jpg")

      assert Pdf.extract_image(path) == cover
    end
  end

  describe "Metadata wrong extraction" do
    setup [:wrong_information]

    test "should return an error tuple when file is not valid", %{path: path} do
      assert {:error, :invalid_type} = Pdf.read_file(path)
    end

    test "should not extract image from a pdf file" do
      path = "test/resources/Brooks-NoSilverBullet.pdf"
      assert {:error, :unsupported_operation} = Pdf.extract_image(path)
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
