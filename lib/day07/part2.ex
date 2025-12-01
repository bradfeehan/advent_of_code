defmodule Day07.Part2 do
  @moduledoc """
  Part 2 — Day 7: Bridge Repair

  Like Part 1, but now includes a third operator: concatenation (`||`).
  The concatenation operator combines digits from left and right into a single number.
  For example, `12 || 345` becomes `12345`.
  """

  @doc """
  Solves part 2 of Day 7.

  Same as Part 1, but now with three operators: `+`, `*`, and `||` (concatenation).
  """
  @spec solve(String.t()) :: integer()
  def solve(input) do
    input
    |> Day07.Part1.parse()
    |> Enum.filter(&valid_equation?/1)
    |> Enum.map(fn {test_value, _operands} -> test_value end)
    |> Enum.sum()
  end

  @doc """
  Checks if an equation can be made true with any combination of +, *, and || operators.
  """
  @spec valid_equation?({integer(), [integer()]}) :: boolean()
  def valid_equation?({test_value, operands}) do
    can_produce?(test_value, operands)
  end

  # Tries all combinations of operators to see if we can produce the target value
  defp can_produce?(target, [first | rest]) do
    try_operators(target, first, rest)
  end

  # Base case: no more operands, check if we've reached the target
  defp try_operators(target, current, []) do
    current == target
  end

  # Recursive case: try +, *, and || with the next operand
  defp try_operators(target, current, [next | rest]) do
    # Early termination: if current already exceeds target, no point continuing
    # (since all operands are positive, result can only grow)
    if current > target do
      false
    else
      try_operators(target, current + next, rest) or
        try_operators(target, current * next, rest) or
        try_operators(target, concat(current, next), rest)
    end
  end

  # Concatenates two integers by combining their digits
  # e.g., concat(12, 345) = 12345
  defp concat(left, right) do
    # Calculate the number of digits in right to shift left appropriately
    multiplier = power_of_10(right)
    left * multiplier + right
  end

  # Returns 10^n where n is the number of digits in the number
  defp power_of_10(0), do: 10
  defp power_of_10(n) when n > 0 do
    digits = :math.floor(:math.log10(n)) + 1
    trunc(:math.pow(10, digits))
  end
end
