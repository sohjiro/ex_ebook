defmodule ExEbook.Metadata.EpubTest do
  use ExUnit.Case
  alias ExEbook.Metadata.Epub

  describe "Metadata correct extraction" do
    setup [:complete_metadata]

    test "should read a epub file", %{path: path} do
      assert {:ok, "<?xml version='1.0' encoding='utf-8'?>" <> _} = Epub.read_file(path)
    end

    test "should read another ebub file" do
      path = "/Users/sohjiro/workspace/jibril/ex_ebook/test/resources/Streams_Java_8.epub"
      assert {:ok, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" <> _} = Epub.read_file(path)
    end

    test "should extract metadata from file", %{path: path} do
      {:ok, data} = Epub.read_file(path)
      assert Epub.extract_metadata(data) == expected_metadata()
    end

    test "should transform metadata into a struct", %{path: path} do
      {:ok, data} = Epub.read_file(path)

      metadata =
        data
        |> Epub.extract_metadata()
        |> Epub.transform()

      assert %ExEbook.Metadata{
        isbn: "ffc21394-2519-4fd6-b3ce-dc5ce40c5c71",
        title: "¡Por Dios, No te Cases! y Otros Relatos Impúdicos",
        language: "es",
        authors: ["EM Ariza"],
        pages: nil,
        publisher: nil,
        subject: nil
      } = metadata
    end

    test "should extract image from an epub file" do
      path = "test/resources/programming-ecto_p1_0.epub"
      cover = File.read("test/resources/programming-ecto_p1_0_cover.jpg")

      assert Epub.extract_image(path) == cover
    end
  end

  describe "Metadata wrong extraction" do
    setup [:wrong_information]

    test "should return an error tuple when file is not valid", %{path: path} do
      assert {:error, :invalid_type} = Epub.read_file(path)
    end
  end

  defp complete_metadata(context) do
    {:ok, Map.put(context, :path, "test/resources/por_dios_no_te_cases!_y_otros_relatos_impúdicos.epub")}
  end

  defp wrong_information(context) do
    {:ok, Map.put(context, :path, "test/resources/something.epub")}
  end

  defp expected_metadata do
    %{
      "title" => "¡Por Dios, No te Cases! y Otros Relatos Impúdicos",
      "language" => "es",
      "creator" => "EM Ariza",
      "contributor" => "calibre (2.53.0) [http://calibre-ebook.com]",
      "identifier" => "ffc21394-2519-4fd6-b3ce-dc5ce40c5c71"
    }
  end
end
