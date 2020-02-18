defmodule ExEbook.Xml do
  @moduledoc """
  Module for handling xml content
  """
  @default_opts [{:namespace_conformant, true}, {:encoding, :latin1}]

  def read_document(text) do
    text
    |> to_charlist()
    |> to_xml()
    |> elem(0)
  end

  def find_elements(xml, path), do: :xmerl_xpath.string(path, xml)

  def text([]), do: nil
  def text([{_, _, _, _, value, _}]),
    do: :unicode.characters_to_binary(value, :latin1)

  defp to_xml(charlist), do: :xmerl_scan.string(charlist, @default_opts)

end

