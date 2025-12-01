defmodule Year2024.Day11.Part2 do
  @moduledoc """
  Part 2 — Day 11: Plutonian Pebbles
  
  Uses a counting approach instead of tracking individual stones.
  We keep a map of stone_value => count, since many stones will have the same value.
  """

  @spec solve(String.t()) :: integer()
  def solve(input) do
    input
    |> parse()
    |> to_counts()
    |> blink(75)
    |> count_stones()
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split(~r/\s+/, trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp to_counts(stones) do
    Enum.frequencies(stones)
  end

  defp blink(counts, 0), do: counts

  defp blink(counts, times) do
    counts
    |> Enum.flat_map(fn {stone, count} ->
      transform(stone)
      |> Enum.map(fn new_stone -> {new_stone, count} end)
    end)
    |> Enum.reduce(%{}, fn {stone, count}, acc ->
      Map.update(acc, stone, count, &(&1 + count))
    end)
    |> blink(times - 1)
  end

  defp transform(0), do: [1]

  defp transform(stone) do
    digits = Integer.to_string(stone)
    len = String.length(digits)

    if rem(len, 2) == 0 do
      mid = div(len, 2)
      {left, right} = String.split_at(digits, mid)
      [String.to_integer(left), String.to_integer(right)]
    else
      [stone * 2024]
    end
  end

  defp count_stones(counts) do
    counts
    |> Map.values()
    |> Enum.sum()
  end
end
