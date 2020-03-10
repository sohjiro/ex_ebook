defmodule ExEbook.Extracter do
  @moduledoc """
  Extracter behaviour for ebooks
  """

  @callback read_file(path :: String.t) :: {:ok, String.t()}
  @callback extract_metadata(data :: String.t) :: map()
  @callback transform(information :: map()) :: %ExEbook.Metadata{}
  @callback extract_image(path :: map()) :: {:ok, binary()}

end
