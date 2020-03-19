defmodule ExEbook.Zip do
  @moduledoc """
  Module for handling zip content
  """
  @type file :: String.t()
  @type path :: String.t()

  @spec open_file_in_memory(path) :: {:ok, pid()}
  def open_file_in_memory(path) do
    path
    |> to_charlist()
    |> :zip.zip_open([:memory])
  end

  @spec read_in_memory_file(pid(), path) :: {:ok, String.t()}
  def read_in_memory_file(zip_pid, path) when is_pid(zip_pid) do
    path
    |> to_charlist()
    |> read_file(zip_pid)
  end

  @spec list_files(pid(), path) :: [path()]
  def list_files(zip_pid, path \\ "/") do
    case :zip.zip_list_dir(zip_pid) do
      {:ok, result} ->
        result
        |> Enum.reduce([], &collect_names(&1, &2, path))

      _ ->
        :error
    end
  end

  defp read_file(file, zip_pid) do
    case :zip.zip_get(file, zip_pid) do
      {:ok, {_filename, document}} ->
        {:ok, document}

      _error ->
        :error
    end
  end

  defp collect_names(value, result, path) do
    value
    |> fetch_name()
    |> to_string()
    |> add_file(result, path)
  end

  defp add_file("", list, "/"), do: list

  defp add_file(name, list, "/"), do: [to_string(name) | list]

  defp add_file(name, list, filter) do
    if String.starts_with?(name, filter) do
      [name | list]
    else
      list
    end
  end

  defp fetch_name({:zip_file, name, _, _, _, _}), do: name
  defp fetch_name(_), do: []
end
