defmodule Year2024.Day11.Stone do
  @moduledoc """
  Shared stone transformation logic for Day 11: Plutonian Pebbles.
  """

  @doc """
  Parse input string into a list of stone values.
  """
  @spec parse(String.t()) :: [integer()]
  def parse(input) do
    input
    |> String.trim()
    |> String.split(~r/\s+/, trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
  Transform a single stone according to the rules:
  - 0 becomes 1
  - Even digit count splits into two stones
  - Otherwise multiply by 2024
  """
  @spec transform(integer()) :: [integer()]
  def transform(0), do: [1]

  def transform(stone) do
    digits = Integer.digits(stone)
    len = length(digits)

    case rem(len, 2) do
      0 ->
        {left, right} = Enum.split(digits, div(len, 2))
        [Integer.undigits(left), Integer.undigits(right)]

      _ ->
        [stone * 2024]
    end
  end

  @doc """
  Blink n times using a counting approach (efficient for large n).
  Takes a map of stone_value => count and returns a map.
  """
  @spec blink_counts(map(), non_neg_integer()) :: map()
  def blink_counts(counts, 0), do: counts

  def blink_counts(counts, times) do
    counts
    |> Enum.flat_map(fn {stone, count} ->
      Enum.map(transform(stone), &{&1, count})
    end)
    |> Enum.reduce(%{}, fn {stone, count}, acc ->
      Map.update(acc, stone, count, &(&1 + count))
    end)
    |> blink_counts(times - 1)
  end

  @doc """
  Count total stones from a frequency map.
  """
  @spec count_stones(map()) :: integer()
  def count_stones(counts), do: counts |> Map.values() |> Enum.sum()

  @doc """
  Convert a list of stones to a frequency map.
  """
  @spec to_counts([integer()]) :: map()
  def to_counts(stones), do: Enum.frequencies(stones)
end
