defmodule Year2024.Day10.Part1 do
  @moduledoc """
  Part 1 — Day 10: Hoof It

  Finds all trailheads (height 0) and calculates their scores by counting
  the number of unique height-9 positions reachable via valid hiking trails.
  A valid trail starts at height 0, ends at height 9, and increases by exactly 1
  at each step, moving only up, down, left, or right.
  """

  @doc """
  Solves part 1 of Day 10.

  Returns the sum of scores of all trailheads on the topographic map.
  """
  @spec solve(String.t()) :: integer()
  def solve(input) do
    grid = parse(input)
    trailheads = find_trailheads(grid)

    scores =
      trailheads
      |> Enum.map(fn {row, col} -> trailhead_score(grid, row, col) end)

    Enum.sum(scores)
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
    |> Enum.map(&String.to_integer/1)
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
  Calculates the score for a trailhead by counting unique height-9 positions
  reachable via valid hiking trails.
  """
  @spec trailhead_score([[integer()]], integer(), integer()) :: integer()
  def trailhead_score(grid, start_row, start_col) do
    reachable_nines = find_reachable_nines(grid, start_row, start_col)
    MapSet.size(reachable_nines)
  end

  @doc """
  Finds all unique height-9 positions reachable from a starting position
  using BFS to explore all valid paths.
  """
  @spec find_reachable_nines([[integer()]], integer(), integer()) :: MapSet.t({integer(), integer()})
  def find_reachable_nines(grid, start_row, start_col) do
    # BFS: queue contains {row, col, current_height}
    queue = [{start_row, start_col, 0}]
    visited = MapSet.new()
    nines = MapSet.new()

    find_reachable_nines(grid, queue, visited, nines)
  end

  defp find_reachable_nines(_grid, [], _visited, nines) do
    nines
  end

  defp find_reachable_nines(grid, [{row, col, _expected_height} | rest], visited, nines) do
    key = {row, col}

    if MapSet.member?(visited, key) do
      find_reachable_nines(grid, rest, visited, nines)
    else
      current_height = get_height(grid, row, col)

      # Skip if position is out of bounds or invalid
      if is_nil(current_height) do
        find_reachable_nines(grid, rest, visited, nines)
      else
        new_visited = MapSet.put(visited, key)

        # If we've reached height 9, mark this position
        new_nines =
          if current_height == 9 do
            MapSet.put(nines, {row, col})
          else
            nines
          end

        # Explore neighbors that are exactly one height higher
        neighbors = get_valid_neighbors(grid, row, col, current_height)
        updated_queue = rest ++ neighbors

        find_reachable_nines(grid, updated_queue, new_visited, new_nines)
      end
    end
  end

  @doc """
  Gets the height at a position in the grid, or nil if out of bounds.
  """
  @spec get_height([[integer()]], integer(), integer()) :: integer() | nil
  def get_height(grid, row, col) do
    case Enum.at(grid, row) do
      nil -> nil
      row_data -> Enum.at(row_data, col)
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
