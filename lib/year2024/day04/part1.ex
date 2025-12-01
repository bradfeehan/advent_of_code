defmodule Year2024.Day04.Part1 do
  @moduledoc """
  Part 1 — Day 4: Ceres Search

  Find all occurrences of "XMAS" in the word search grid.
  Words can be horizontal, vertical, diagonal, and written backwards.
  """

  @word ~c"XMAS"
  @directions [
    {0, 1},   # right
    {0, -1},  # left
    {1, 0},   # down
    {-1, 0},  # up
    {1, 1},   # down-right
    {1, -1},  # down-left
    {-1, 1},  # up-right
    {-1, -1}  # up-left
  ]

  @doc """
  Counts how many times XMAS appears in the word search grid.
  """
  @spec solve(String.t()) :: integer()
  def solve(input) do
    grid = parse_grid(input)

    grid
    |> find_starting_positions(?X)
    |> Enum.map(fn pos -> count_xmas_from(grid, pos) end)
    |> Enum.sum()
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

  @spec find_starting_positions(%{{integer(), integer()} => char()}, char()) ::
          [{integer(), integer()}]
  defp find_starting_positions(grid, char) do
    grid
    |> Enum.filter(fn {_pos, c} -> c == char end)
    |> Enum.map(fn {pos, _c} -> pos end)
  end

  @spec count_xmas_from(%{{integer(), integer()} => char()}, {integer(), integer()}) :: integer()
  defp count_xmas_from(grid, start_pos) do
    @directions
    |> Enum.count(fn direction -> word_matches?(grid, start_pos, direction) end)
  end

  @spec word_matches?(
          %{{integer(), integer()} => char()},
          {integer(), integer()},
          {integer(), integer()}
        ) :: boolean()
  defp word_matches?(grid, {row, col}, {dr, dc}) do
    @word
    |> Enum.with_index()
    |> Enum.all?(fn {char, i} ->
      pos = {row + dr * i, col + dc * i}
      Map.get(grid, pos) == char
    end)
  end
end
