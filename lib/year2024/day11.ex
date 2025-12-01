defmodule Year2024.Day11 do
  @moduledoc """
  Day 11 — Day 11: Plutonian Pebbles
  """

  @spec part(1 | 2, String.t()) :: term()
  def part(1, input), do: Year2024.Day11.Part1.solve(input)
  def part(2, input), do: Year2024.Day11.Part2.solve(input)

  def part(part, _input) do
    raise ArgumentError, "unsupported part #{inspect(part)} for Year2024.Day11"
  end
end
