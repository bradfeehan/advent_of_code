defmodule Day19 do
  @moduledoc """
  Day 19 — Day 19: Linen Layout
  """

  @spec part(1 | 2, String.t()) :: term()
  def part(1, input), do: Day19.Part1.solve(input)
  def part(2, _input) do
    raise "Part 2 is not yet unlocked"
  end

  def part(part, _input) do
    raise ArgumentError, "unsupported part #{inspect(part)} for Day19"
  end
end
