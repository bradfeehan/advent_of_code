defmodule Day03.Part1 do
  @moduledoc """
  Part 1 — Day 3: Mull It Over

  Scan corrupted memory for valid `mul(X,Y)` instructions where X and Y
  are 1-3 digit numbers. Sum up all the multiplication results.
  """

  @mul_pattern ~r/mul\((\d{1,3}),(\d{1,3})\)/

  @spec solve(String.t()) :: integer()
  def solve(input) do
    @mul_pattern
    |> Regex.scan(input)
    |> Enum.map(fn [_full_match, x, y] ->
      String.to_integer(x) * String.to_integer(y)
    end)
    |> Enum.sum()
  end
end
