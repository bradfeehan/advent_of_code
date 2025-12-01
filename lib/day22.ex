defmodule Day22 do
  @moduledoc """
  Day 22 — Day 22: Monkey Market
  """

  @spec part(1 | 2, String.t()) :: term()
  def part(1, input), do: Day22.Part1.solve(input)
  def part(2, _input) do
    raise "Part 2 is not yet unlocked"
  end

  def part(part, _input) do
    raise ArgumentError, "unsupported part #{inspect(part)} for Day22"
  end
end
