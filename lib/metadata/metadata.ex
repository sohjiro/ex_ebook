defmodule ExEbook.Metadata do
  @moduledoc """
  Behaviour module
  """
  defstruct ~w[
    isbn
    title
    language
    authors
    pages
    publisher
    subject
    cover
  ]a
end
