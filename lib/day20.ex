defmodule Day20 do
  @moduledoc """
  Day 20 — Day 20: Race Condition
  """

  @spec part(1 | 2, String.t()) :: term()
  def part(1, input), do: Day20.Part1.solve(input)
  def part(2, _input) do
    raise "Part 2 is not yet unlocked"
  end

  def part(part, _input) do
    raise ArgumentError, "unsupported part #{inspect(part)} for Day20"
  end
end
