defmodule Day02 do
  @moduledoc """
  Day 02 — Day 2: Red-Nosed Reports
  """

  @spec part(1 | 2, String.t()) :: term()
  def part(1, input), do: Day02.Part1.solve(input)
  def part(2, input), do: Day02.Part2.solve(input)

  def part(part, _input) do
    raise ArgumentError, "unsupported part #{inspect(part)} for Day02"
  end
end
