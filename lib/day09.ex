defmodule Day09 do
  @moduledoc """
  Day 09 — Day 9: Disk Fragmenter
  """

  @spec part(1 | 2, String.t()) :: term()
  def part(1, input), do: Day09.Part1.solve(input)
  def part(2, input), do: Day09.Part2.solve(input)

  def part(part, _input) do
    raise ArgumentError, "unsupported part #{inspect(part)} for Day09"
  end
end
