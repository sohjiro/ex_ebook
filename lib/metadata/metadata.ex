defmodule ExEbook.Metadata do
  @moduledoc """
  Behaviour module
  """
  defstruct ~w[title authors pages page_size file_size creator]a

  @callback read_file(path :: String.t) :: String.t()
  @callback extract_metadata(data :: String.t) :: map()
  @callback transform(information :: list()) :: %__MODULE__{}

end
