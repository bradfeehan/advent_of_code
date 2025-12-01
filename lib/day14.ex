defmodule Day14 do
  @moduledoc """
  Day 14 — Day 14: Restroom Redoubt
  """

  @spec part(1 | 2, String.t()) :: term()
  def part(1, input), do: Day14.Part1.solve(input)
  def part(2, _input) do
    raise "Part 2 is not yet unlocked"
  end

  def part(part, _input) do
    raise ArgumentError, "unsupported part #{inspect(part)} for Day14"
  end
end
