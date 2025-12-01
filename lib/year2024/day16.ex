defmodule Year2024.Day16 do
  @moduledoc """
  Day 16 — Day 16: Reindeer Maze
  """

  @spec part(1 | 2, String.t()) :: term()
  def part(1, input), do: Year2024.Day16.Part1.solve(input)
  def part(2, _input) do
    raise "Part 2 is not yet unlocked"
  end

  def part(part, _input) do
    raise ArgumentError, "unsupported part #{inspect(part)} for Year2024.Day16"
  end
end
