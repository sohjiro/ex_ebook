defmodule ExEbook.Metadata.MobiTest do
  use ExUnit.Case
  alias ExEbook.Metadata.Mobi

  describe "Metadata correct extraction" do
    setup [:complete_metadata]

    test "should read a mobi file", %{path: path} do
      assert {:ok, _} = Mobi.read_file(path)
    end

    test "should extract metadata from file", %{path: path} do
      {:ok, data} = Mobi.read_file(path)
      assert Mobi.extract_metadata(data) == expected_metadata()
    end

    test "should extract image from a mobi file", %{path: path} do
      cover = File.read("test/resources/resource00000.jpg")

      assert Mobi.extract_image(path) == cover
    end
  end

  describe "Metadata wrong extraction" do
    setup [:wrong_information]

    test "should return an error tuple when file is not valid", %{path: path} do
      assert {:error, :invalid_type} = Mobi.read_file(path)
    end
  end

  defp complete_metadata(context) do
    {:ok, Map.put(context, :path, "test/resources/pg11861.mobi")}
  end

  defp wrong_information(context) do
    {:ok, Map.put(context, :path, "test/resources/something.mobi")}
  end

  defp expected_metadata do
    %{
      "Title" => "Radio Boys Cronies / Or, Bill Brown's Radio",
      "Author" => "S. F. Aaron; Wayne Whipple",
      "Subject" =>
        "Boys -- Juvenile fiction; Radio -- Juvenile fiction; Inventors -- Juvenile fiction; New York (State) -- Juvenile fiction",
      "Publishing date" => "2004-03-01",
      "Copyright" => "Public domain in the USA.",
      "Language" => "en (utf8)",
      "Creator software" => "kindlegen 2.9.0 (linux)",
      "Mobi version" => "8 (hybrid with version 6)"
    }
  end
end
