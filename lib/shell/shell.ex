defmodule ExEbook.Shell do
  @moduledoc """
  Module for interacting with the shell
  """
  @type cmd :: String.t()
  @type path :: String.t()
  @type params :: [String.t()]

  require Logger

  @spec execute(cmd, params) :: {:ok, String.t()}
  def execute(cmd, params \\ []) do
    case System.cmd(cmd, params) do
      {data, 0} ->
        {:ok, data}

      error ->
        Logger.error("#{inspect(__MODULE__)} error #{inspect(error)}")
        {:error, :invalid_type}
    end
  end

  @spec current_tmp_dir :: path()
  def current_tmp_dir do
    System.tmp_dir()
  end
end
