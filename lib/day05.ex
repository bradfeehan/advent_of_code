defmodule Day05 do
  @moduledoc """
  Day 05 — Day 5: Print Queue
  """

  @spec part(1 | 2, String.t()) :: term()
  def part(1, input), do: Day05.Part1.solve(input)
  def part(2, input), do: Day05.Part2.solve(input)

  def part(part, _input) do
    raise ArgumentError, "unsupported part #{inspect(part)} for Day05"
  end
end
