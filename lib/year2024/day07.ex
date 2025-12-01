defmodule Year2024.Day07 do
  @moduledoc """
  Day 07 — Day 7: Bridge Repair
  """

  @spec part(1 | 2, String.t()) :: term()
  def part(1, input), do: Year2024.Day07.Part1.solve(input)
  def part(2, input), do: Year2024.Day07.Part2.solve(input)

  def part(part, _input) do
    raise ArgumentError, "unsupported part #{inspect(part)} for Year2024.Day07"
  end
end
