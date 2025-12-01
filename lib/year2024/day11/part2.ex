defmodule Year2024.Day11.Part2 do
  @moduledoc """
  Part 2 — Day 11: Plutonian Pebbles

  Uses a counting approach instead of tracking individual stones.
  We keep a map of stone_value => count, since many stones will have the same value.
  """

  alias Year2024.Day11.Stone

  @spec solve(String.t()) :: integer()
  def solve(input) do
    input
    |> Stone.parse()
    |> Stone.to_counts()
    |> Stone.blink_counts(75)
    |> Stone.count_stones()
  end
end
