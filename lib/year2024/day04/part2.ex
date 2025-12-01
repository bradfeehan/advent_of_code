defmodule Year2024.Day04.Part2 do
  @moduledoc """
  Part 2 — Day 4: Ceres Search

  Find all X-MAS patterns: two "MAS" arranged in an X shape with 'A' at the center.
  Each MAS can be written forwards or backwards.
  """

  @doc """
  Counts how many X-MAS patterns appear in the word search grid.
  """
  @spec solve(String.t()) :: integer()
  def solve(input) do
    grid = parse_grid(input)

    grid
    |> find_positions(?A)
    |> Enum.count(fn pos -> x_mas?(grid, pos) end)
  end

  @spec parse_grid(String.t()) :: %{{integer(), integer()} => char()}
  defp parse_grid(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, row} ->
      line
      |> String.to_charlist()
      |> Enum.with_index()
      |> Enum.map(fn {char, col} -> {{row, col}, char} end)
    end)
    |> Map.new()
  end

  @spec find_positions(%{{integer(), integer()} => char()}, char()) ::
          [{integer(), integer()}]
  defp find_positions(grid, char) do
    grid
    |> Enum.filter(fn {_pos, c} -> c == char end)
    |> Enum.map(fn {pos, _c} -> pos end)
  end

  @spec x_mas?(%{{integer(), integer()} => char()}, {integer(), integer()}) :: boolean()
  defp x_mas?(grid, {row, col}) do
    # Check both diagonals form MAS or SAM
    # Diagonal 1: top-left to bottom-right
    diag1 = [
      Map.get(grid, {row - 1, col - 1}),
      ?A,
      Map.get(grid, {row + 1, col + 1})
    ]

    # Diagonal 2: top-right to bottom-left
    diag2 = [
      Map.get(grid, {row - 1, col + 1}),
      ?A,
      Map.get(grid, {row + 1, col - 1})
    ]

    mas_or_sam?(diag1) and mas_or_sam?(diag2)
  end

  @spec mas_or_sam?([char() | nil]) :: boolean()
  defp mas_or_sam?(chars) do
    chars == ~c"MAS" or chars == ~c"SAM"
  end
end
