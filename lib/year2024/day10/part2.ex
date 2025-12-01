defmodule Year2024.Day10.Part2 do
  @moduledoc """
  Part 2 — Day 10: Hoof It

  Finds all trailheads (height 0) and calculates their ratings by counting
  the number of distinct hiking trails that begin at each trailhead.
  A valid trail starts at height 0, ends at height 9, and increases by exactly 1
  at each step, moving only up, down, left, or right.
  """

  @doc """
  Solves part 2 of Day 10.

  Returns the sum of ratings of all trailheads on the topographic map.
  """
  @spec solve(String.t()) :: integer()
  def solve(input) do
    grid = parse(input)
    trailheads = find_trailheads(grid)

    # Build memoization cache for path counts (shared across all trailheads)
    cache = %{}

    {ratings, _final_cache} =
      trailheads
      |> Enum.reduce({[], cache}, fn {row, col}, {acc_ratings, acc_cache} ->
        {count, new_cache} = count_paths(grid, row, col, acc_cache)
        {[count | acc_ratings], new_cache}
      end)

    Enum.sum(ratings)
  end

  @doc """
  Parses the input string into a 2D grid of integers.
  """
  @spec parse(String.t()) :: [[integer()]]
  def parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(row) do
    row
    |> String.graphemes()
    |> Enum.map(fn
      "." -> nil
      digit -> String.to_integer(digit)
    end)
  end

  @doc """
  Finds all trailhead positions (height 0) in the grid.
  """
  @spec find_trailheads([[integer()]]) :: [{integer(), integer()}]
  def find_trailheads(grid) do
    grid
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, row_idx} ->
      row
      |> Enum.with_index()
      |> Enum.filter(fn {height, _col_idx} -> height == 0 end)
      |> Enum.map(fn {_height, col_idx} -> {row_idx, col_idx} end)
    end)
  end

  @doc """
  Counts the number of distinct paths from a position to any height-9 position.
  Uses memoization to avoid recalculating the same positions.
  Returns {count, updated_cache}.
  """
  @spec count_paths([[integer()]], integer(), integer(), map()) :: {integer(), map()}
  def count_paths(grid, row, col, cache) do
    key = {row, col}

    case Map.get(cache, key) do
      nil ->
        current_height = get_height(grid, row, col)

        {count, updated_cache} =
          if is_nil(current_height) do
            {0, cache}
          else
            if current_height == 9 do
              # If we're at height 9, there's exactly 1 path ending here
              {1, Map.put(cache, key, 1)}
            else
              # Sum paths from all valid neighbors
              neighbors = get_valid_neighbors(grid, row, col, current_height)

              {count, final_cache} =
                Enum.reduce(neighbors, {0, cache}, fn {n_row, n_col, _expected_height}, {acc_count, acc_cache} ->
                  {n_count, n_cache} = count_paths(grid, n_row, n_col, acc_cache)
                  {acc_count + n_count, n_cache}
                end)

              {count, Map.put(final_cache, key, count)}
            end
          end

        {count, updated_cache}
      count ->
        {count, cache}
    end
  end

  @doc """
  Gets the height at a position in the grid, or nil if out of bounds.
  """
  @spec get_height([[integer() | nil]], integer(), integer()) :: integer() | nil
  def get_height(grid, row, col) do
    case Enum.at(grid, row) do
      nil -> nil
      row_data ->
        case Enum.at(row_data, col) do
          nil -> nil
          height -> height
        end
    end
  end

  @doc """
  Gets valid neighboring positions that are exactly one height higher.
  """
  @spec get_valid_neighbors([[integer()]], integer(), integer(), integer()) :: [{integer(), integer(), integer()}]
  def get_valid_neighbors(grid, row, col, current_height) do
    target_height = current_height + 1
    num_rows = length(grid)
    num_cols = if num_rows > 0, do: length(Enum.at(grid, 0)), else: 0

    [
      {row - 1, col},
      {row + 1, col},
      {row, col - 1},
      {row, col + 1}
    ]
    |> Enum.filter(fn {r, c} ->
      # Check bounds first
      r >= 0 and r < num_rows and c >= 0 and c < num_cols
    end)
    |> Enum.filter(fn {r, c} ->
      case get_height(grid, r, c) do
        ^target_height -> true
        _ -> false
      end
    end)
    |> Enum.map(fn {r, c} -> {r, c, target_height} end)
  end
end
