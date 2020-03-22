defmodule ExEbook.Xml do
  @moduledoc """
  Module for handling xml content
  """
  @type xpath :: charlist()
  @default_opts [{:namespace_conformant, true}, {:encoding, :latin1}]

  require Record

  Record.defrecord(
    :xmlAttribute,
    Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")
  )

  Record.defrecord(:xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl"))

  @spec read_document(String.t()) :: tuple()
  def read_document(text) do
    text
    |> to_charlist()
    |> to_xml()
    |> elem(0)
  end

  @spec find_elements(tuple, xpath()) :: [tuple()]
  def find_elements(xml, xpath), do: :xmerl_xpath.string(xpath, xml)

  @spec text([tuple()]) :: String.t()
  def text([xmlText(value: value)]),
    do: :unicode.characters_to_binary(value, :latin1)

  def text(_), do: nil

  @spec extract_attr([tuple()]) :: String.t()
  def extract_attr([xmlAttribute(value: value) | _]),
    do: :unicode.characters_to_binary(value, :latin1)

  def extract_attr(_), do: nil

  defp to_xml(charlist), do: :xmerl_scan.string(charlist, @default_opts)
end
