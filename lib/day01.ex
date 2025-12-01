defmodule Day01 do
  @moduledoc """
  Day 01 — Day 1: Historian Hysteria
  """

  @spec part(1 | 2, String.t()) :: term()
  def part(1, input), do: Day01.Part1.solve(input)
  def part(2, input), do: Day01.Part2.solve(input)

  def part(part, _input) do
    raise ArgumentError, "unsupported part #{inspect(part)} for Day01"
  end
end
