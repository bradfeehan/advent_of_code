defmodule Year2024.Day11.Part1 do
  @moduledoc """
  Part 1 — Day 11: Plutonian Pebbles
  """

  alias Year2024.Day11.Stone

  @spec solve(String.t()) :: integer()
  def solve(input) do
    input
    |> Stone.parse()
    |> Stone.to_counts()
    |> Stone.blink_counts(25)
    |> Stone.count_stones()
  end
end
