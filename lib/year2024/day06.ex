defmodule Year2024.Day06 do
  @moduledoc """
  Day 06 — Day 6: Guard Gallivant
  """

  @spec part(1 | 2, String.t()) :: term()
  def part(1, input), do: Year2024.Day06.Part1.solve(input)
  def part(2, input), do: Year2024.Day06.Part2.solve(input)

  def part(part, _input) do
    raise ArgumentError, "unsupported part #{inspect(part)} for Year2024.Day06"
  end
end
