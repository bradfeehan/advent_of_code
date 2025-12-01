defmodule Year2024.Day01.Part2 do
  @moduledoc """
  Part 2 — Day 1: Historian Hysteria
  """

  @spec solve(String.t()) :: integer()
  def solve(input) do
    {left, right} = parse_lists(input)
    right_counts = Enum.frequencies(right)

    left
    |> Enum.map(fn num -> num * Map.get(right_counts, num, 0) end)
    |> Enum.sum()
  end

  defp parse_lists(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
    |> Enum.unzip()
  end

  defp parse_line(line) do
    [left, right] = String.split(line, ~r/\s+/, trim: true)
    {String.to_integer(left), String.to_integer(right)}
  end
end
