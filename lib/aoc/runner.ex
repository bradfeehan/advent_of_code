defmodule Aoc.Runner do
  @moduledoc """
  Loads the generated modules for a given day and executes the requested part.
  """

  @base_url "https://adventofcode.com"

  @spec run(pos_integer(), pos_integer(), keyword()) :: {:ok, term()} | {:error, term()}
  def run(day, part, opts \\ []) do
    project_root = Keyword.get(opts, :project_root, File.cwd!())
    module = AdventOfCode2024.day_module(day)

    input_path =
      Path.join([project_root, "priv", AdventOfCode2024.day_directory(day), "input.txt"])

    with {:ok, input} <- File.read(input_path),
         {:module, _} <- Code.ensure_loaded(module),
         true <- function_exported?(module, :part, 2) do
      {:ok, apply(module, :part, [part, input])}
    else
      false -> {:error, :missing_part}
      {:error, :enoent} -> {:error, :missing_input}
      {:error, :nofile} -> {:error, :missing_module}
      {:error, reason} -> {:error, reason}
    end
  end

  @spec submission_url(pos_integer(), keyword()) :: String.t()
  def submission_url(day, opts \\ []) do
    year = Keyword.get(opts, :year, AdventOfCode2024.year())
    "#{@base_url}/#{year}/day/#{day}/answer"
  end
end
