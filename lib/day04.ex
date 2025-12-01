defmodule Day04 do
  @moduledoc """
  Day 04 — Day 4: Ceres Search
  """

  @spec part(1 | 2, String.t()) :: term()
  def part(1, input), do: Day04.Part1.solve(input)
  def part(2, input), do: Day04.Part2.solve(input)

  def part(part, _input) do
    raise ArgumentError, "unsupported part #{inspect(part)} for Day04"
  end
end
