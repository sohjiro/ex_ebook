defmodule ExEbook.Shell do
  @moduledoc """
  Module for interacting with the shell
  """
  require Logger

  def execute(cmd, params \\ []) do
    case System.cmd(cmd, params) do
      {data, 0} ->
        {:ok, data}

      error ->
        Logger.error("#{inspect __MODULE__} error #{inspect error}")
        {:error, :invalid_type}
    end
  end

end
