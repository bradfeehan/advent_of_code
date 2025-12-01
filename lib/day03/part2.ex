defmodule Day03.Part2 do
  @moduledoc """
  Part 2 — Day 3: Mull It Over

  Like Part 1, but now handle `do()` and `don't()` instructions that
  enable/disable future `mul` instructions. At the beginning, `mul`
  instructions are enabled.
  """

  @instruction_pattern ~r/mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)/

  @spec solve(String.t()) :: integer()
  def solve(input) do
    @instruction_pattern
    |> Regex.scan(input, capture: :all)
    |> Enum.reduce({true, 0}, fn
      ["do()"], {_enabled, sum} ->
        {true, sum}

      ["don't()"], {_enabled, sum} ->
        {false, sum}

      [_full_match, x, y], {true, sum} ->
        {true, sum + String.to_integer(x) * String.to_integer(y)}

      [_mul_match | _], {false, sum} ->
        {false, sum}
    end)
    |> elem(1)
  end
end
