defmodule Year2024.Day11.Part1 do
  @moduledoc """
  Part 1 — Day 11: Plutonian Pebbles
  """

  @spec solve(String.t()) :: integer()
  def solve(input) do
    input
    |> parse()
    |> blink(25)
    |> length()
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split(~r/\s+/, trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp blink(stones, 0), do: stones

  defp blink(stones, times) do
    stones
    |> Enum.flat_map(&transform/1)
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
end
