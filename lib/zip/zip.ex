defmodule ExEbook.Zip do
  @moduledoc """
  Module for handling zip content
  """

  def open_file_in_memory(file) do
    file
    |> to_charlist()
    |> :zip.zip_open([:memory])
  end

  def read_in_memory_file(zip_pid, file) when is_pid(zip_pid) do
    file
    |> to_charlist()
    |> read_file(zip_pid)
  end

  defp read_file(file, zip_pid) do
    case :zip.zip_get(file, zip_pid) do
      {:ok, {_filename, document}} ->
        {:ok, document}

      _error ->
        :error
    end
  end


end
