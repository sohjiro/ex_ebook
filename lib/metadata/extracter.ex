defmodule ExEbook.Extracter do
  @moduledoc """
  Extracter behaviour for ebooks
  """

  @callback read_file(path :: String.t) :: {:ok, String.t()}
  @callback extract_metadata(data :: String.t) :: map()
  @callback transform(information :: map()) :: %ExEbook.Metadata{}
  # @callback image(path :: map()) :: File.t()

# $> pdfimages -raw -f 1 -l 1 -list /Users/sohjiro/Downloads/programming-ecto_p1_0.pdf ~/Downloads/
# /Users/sohjiro/Downloads/-0000.jpg: page=1 width=2250 height=2700 hdpi=300.00 vdpi=299.70 colorspace=DeviceRGB bpc=8

end
