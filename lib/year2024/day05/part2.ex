defmodule Year2024.Day05.Part2 do
  @moduledoc """
  Part 2 — Day 5: Print Queue

  Finds incorrectly-ordered updates, reorders them according to the rules,
  and sums the middle page numbers of the corrected updates.
  """

  alias Year2024.Day05.Part1

  @doc """
  Solves Part 2 of Day 5.

  Takes the puzzle input, finds incorrectly ordered updates, fixes their
  ordering according to the rules, and returns the sum of their middle
  page numbers.
  """
  @spec solve(String.t()) :: integer()
  def solve(input) do
    {rules, updates} = Part1.parse_input(input)

    updates
    |> Enum.reject(&Part1.valid_order?(&1, rules))
    |> Enum.map(&reorder(&1, rules))
    |> Enum.map(&Part1.middle_page/1)
    |> Enum.sum()
  end

  @doc """
  Reorders an update according to the rules.

  Uses a custom sort comparator that checks if there's a rule defining
  the ordering between any two pages.
  """
  @spec reorder([integer()], MapSet.t()) :: [integer()]
  def reorder(update, rules) do
    Enum.sort(update, fn a, b ->
      cond do
        # If there's a rule saying a must come before b, a < b
        MapSet.member?(rules, {a, b}) -> true
        # If there's a rule saying b must come before a, a > b
        MapSet.member?(rules, {b, a}) -> false
        # No rule between them, maintain order
        true -> true
      end
    end)
  end
end
