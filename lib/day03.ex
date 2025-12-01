defmodule Day03 do
  @moduledoc """
  Day 03 — Day 3: Mull It Over
  """

  @spec part(1 | 2, String.t()) :: term()
  def part(1, input), do: Day03.Part1.solve(input)
  def part(2, input), do: Day03.Part2.solve(input)

  def part(part, _input) do
    raise ArgumentError, "unsupported part #{inspect(part)} for Day03"
  end
end
