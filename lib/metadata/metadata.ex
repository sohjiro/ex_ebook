defmodule ExEbook.Metadata do
  @moduledoc """
  Behaviour module
  """
  @type t :: %__MODULE__{}

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
