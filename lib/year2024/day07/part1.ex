defmodule Year2024.Day07.Part1 do
  @moduledoc """
  Part 1 — Day 7: Bridge Repair

  Determines which calibration equations can be made true by inserting
  `+` and `*` operators between numbers (evaluated left-to-right).
  Returns the sum of test values for valid equations.
  """

  @doc """
  Solves part 1 of Day 7.

  Parses each line as a test value and operands, then checks if any combination
  of `+` and `*` operators can produce the test value. Returns the sum of all
  valid test values.
  """
  @spec solve(String.t()) :: integer()
  def solve(input) do
    input
    |> parse()
    |> Enum.filter(&valid_equation?/1)
    |> Enum.map(fn {test_value, _operands} -> test_value end)
    |> Enum.sum()
  end

  @doc """
  Parses the input string into a list of {test_value, operands} tuples.
  """
  @spec parse(String.t()) :: [{integer(), [integer()]}]
  def parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [test_value_str, operands_str] = String.split(line, ": ")
    test_value = String.to_integer(test_value_str)

    operands =
      operands_str
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)

    {test_value, operands}
  end

  @doc """
  Checks if an equation can be made true with any combination of + and * operators.
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

  # Recursive case: try both + and * with the next operand
  defp try_operators(target, current, [next | rest]) do
    # Early termination: if current already exceeds target, no point continuing
    # (since all operands are positive, result can only grow)
    if current > target do
      false
    else
      try_operators(target, current + next, rest) or
        try_operators(target, current * next, rest)
    end
  end
end
