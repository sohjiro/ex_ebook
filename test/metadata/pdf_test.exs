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

    test "should transform weird data" do
      data = weird_metadata()
      assert Pdf.extract_metadata(data) == weird_metadata_expected()
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

  defp weird_metadata do
    """
    Title:          Think Java\nAuthor:         \n            \nCreator:        AH CSS Formatter V6.2 MR4 for Linux64 : 6.2.6.18551 (2014/09/24 15:00JST)\nProducer:       Antenna House PDF Output Library 6.2.609 (Linux64)\nCreationDate:   Mon Apr 17 16:44:35 2017\nModDate:        Thu Apr 20 13:06:39 2017\nTagged:         no\nForm:           none\nPages:          251\nEncrypted:      no\nPage size:      504 x 661.464 pts (rotated 0 degrees)\nFile size:      5850277 bytes\nOptimized:      no\nPDF version:    1.6\n
    """
  end

  defp weird_metadata_expected do
    %{
      "Title" => "Think Java",
      "Author" => "",
      "Creator" => "AH CSS Formatter V6.2 MR4 for Linux64 : 6.2.6.18551 (2014/09/24 15:00JST)",
      "Producer" => "Antenna House PDF Output Library 6.2.609 (Linux64)",
      "CreationDate" => "Mon Apr 17 16:44:35 2017",
      "ModDate" => "Thu Apr 20 13:06:39 2017",
      "Tagged" => "no",
      "Form" => "none",
      "Pages" => "251",
      "Encrypted" => "no",
      "Page size" => "504 x 661.464 pts (rotated 0 degrees)",
      "File size" => "5850277 bytes",
      "Optimized" => "no",
      "PDF version" => "1.6"
    }
  end
end
