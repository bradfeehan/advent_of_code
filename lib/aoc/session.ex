defmodule Aoc.Session do
  @moduledoc """
  Persists and retrieves the Advent of Code session cookie used for authenticated
  HTTP requests.
  """

  @session_filename ".aoc_session"

  @doc """
  Returns the absolute path to the session file.
  """
  @spec file_path(keyword()) :: String.t()
  def file_path(opts \\ []) do
    opts
    |> Keyword.get(:project_root, File.cwd!())
    |> Path.join(@session_filename)
  end

  @doc """
  Loads the session cookie from disk.
  """
  @spec load(keyword()) :: {:ok, String.t()} | {:error, atom()}
  def load(opts \\ []) do
    opts
    |> file_path()
    |> File.read()
    |> case do
      {:ok, value} ->
        value = String.trim(value)

        if value == "" do
          {:error, :missing_session}
        else
          {:ok, value}
        end

      {:error, :enoent} ->
        {:error, :missing_session}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Saves the provided session cookie to disk.
  """
  @spec save(String.t(), keyword()) :: :ok | {:error, atom() | pos_integer()}
  def save(cookie, opts \\ []) when is_binary(cookie) do
    trimmed = String.trim(cookie)

    if trimmed == "" do
      {:error, :invalid_session}
    else
      opts
      |> file_path()
      |> File.write(trimmed <> "\n")
    end
  end
end
