defmodule AdventOfCode2024 do
  @moduledoc """
  Shared helpers and constants for the Advent of Code 2024 workspace.
  """

  @year 2024

  @doc """
  Returns the canonical Advent of Code year for this workspace.
  """
  @spec year() :: pos_integer()
  def year, do: @year

  @doc """
  Formats the given day as a zero-padded string (e.g. `01` for day 1).
  """
  @spec day_slug(pos_integer()) :: String.t()
  def day_slug(day) when day in 1..25 do
    day
    |> Integer.to_string()
    |> String.pad_leading(2, "0")
  end

  def day_slug(day) do
    raise ArgumentError, "day must be between 1 and 25, got: #{inspect(day)}"
  end

  @doc """
  Returns the module expected to contain the implementation for the given day.
  """
  @spec day_module(pos_integer()) :: module()
  def day_module(day) do
    Module.concat([:"Day#{day_slug(day)}"])
  end

  @doc """
  Returns the directory name used for storing files for the given day.
  """
  @spec day_directory(pos_integer()) :: String.t()
  def day_directory(day), do: "day#{day_slug(day)}"
end
