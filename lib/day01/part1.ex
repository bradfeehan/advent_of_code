defmodule Day01.Part1 do
  @moduledoc """
  Part 1 — Day 1: Historian Hysteria
  """

  @spec solve(String.t()) :: integer()
  def solve(input) do
    {left, right} = parse_lists(input)

    Enum.sort(left)
    |> Enum.zip(Enum.sort(right))
    |> Enum.map(fn {l, r} -> abs(l - r) end)
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
