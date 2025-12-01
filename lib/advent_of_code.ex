defmodule AdventOfCode do
  @moduledoc """
  Shared helpers and constants for Advent of Code workspaces across multiple years.
  """

  @doc """
  Returns the current year dynamically.
  """
  @spec year() :: pos_integer()
  def year, do: Date.utc_today().year

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
  Returns the module expected to contain the implementation for the given day and year.
  """
  @spec day_module(pos_integer(), pos_integer()) :: module()
  def day_module(year, day) do
    Module.concat([:"Year#{year}", :"Day#{day_slug(day)}"])
  end

  @doc """
  Returns the directory name used for storing files for the given day and year.
  """
  @spec day_directory(pos_integer(), pos_integer()) :: String.t()
  def day_directory(year, day), do: "year#{year}/day#{day_slug(day)}"
end
