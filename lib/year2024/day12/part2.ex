defmodule Year2024.Day12.Part2 do
  @moduledoc """
  Part 2 — Day 12: Garden Groups

  Calculates the total price of fencing all garden regions on the map using bulk discount.
  Each region's price is its area multiplied by the number of sides (straight fence sections).
  """

  alias Year2024.Day12.Part1

  @type position :: {integer(), integer()}

  @doc """
  Solves part 2 by finding all regions and calculating total fence price using sides.
  """
  @spec solve(String.t()) :: integer()
  def solve(input) do
    grid = Part1.parse(input)

    grid
    |> Part1.find_all_regions()
    |> Enum.map(&region_price_with_sides/1)
    |> Enum.sum()
  end

  @doc """
  Calculates the fence price for a region (area * number of sides).
  """
  @spec region_price_with_sides(MapSet.t(position())) :: integer()
  def region_price_with_sides(region) do
    area = Part1.region_area(region)
    sides = count_sides(region)
    area * sides
  end

  @doc """
  Counts the number of distinct sides (straight fence sections) for a region.
  A side is a contiguous straight line of fence edges.
  """
  @spec count_sides(MapSet.t(position())) :: integer()
  def count_sides(region) do
    # For each direction, find all fence edges and count distinct sides
    # Edges are grouped by their row (for horizontal) or column (for vertical)
    # and then we count contiguous segments

    # Top edges: cells where the cell above is not in the region
    top_edges = find_edges(region, fn {row, col} -> {row - 1, col} end)
    top_sides = count_horizontal_sides(top_edges)

    # Bottom edges: cells where the cell below is not in the region
    bottom_edges = find_edges(region, fn {row, col} -> {row + 1, col} end)
    bottom_sides = count_horizontal_sides(bottom_edges)

    # Left edges: cells where the cell to the left is not in the region
    left_edges = find_edges(region, fn {row, col} -> {row, col - 1} end)
    left_sides = count_vertical_sides(left_edges)

    # Right edges: cells where the cell to the right is not in the region
    right_edges = find_edges(region, fn {row, col} -> {row, col + 1} end)
    right_sides = count_vertical_sides(right_edges)

    top_sides + bottom_sides + left_sides + right_sides
  end

  # Find all positions that have an edge in a given direction
  defp find_edges(region, neighbor_fn) do
    region
    |> Enum.filter(fn pos ->
      neighbor = neighbor_fn.(pos)
      not MapSet.member?(region, neighbor)
    end)
    |> MapSet.new()
  end

  # Count contiguous horizontal sides (grouped by row)
  defp count_horizontal_sides(edges) do
    edges
    |> Enum.group_by(fn {row, _col} -> row end)
    |> Enum.map(fn {_row, positions} ->
      positions
      |> Enum.map(fn {_row, col} -> col end)
      |> Enum.sort()
      |> count_contiguous_segments()
    end)
    |> Enum.sum()
  end

  # Count contiguous vertical sides (grouped by column)
  defp count_vertical_sides(edges) do
    edges
    |> Enum.group_by(fn {_row, col} -> col end)
    |> Enum.map(fn {_col, positions} ->
      positions
      |> Enum.map(fn {row, _col} -> row end)
      |> Enum.sort()
      |> count_contiguous_segments()
    end)
    |> Enum.sum()
  end

  # Count how many contiguous segments exist in a sorted list of integers
  # e.g., [1, 2, 3, 5, 6, 9] -> 3 segments ([1,2,3], [5,6], [9])
  defp count_contiguous_segments([]), do: 0
  defp count_contiguous_segments([_single]), do: 1

  defp count_contiguous_segments([first | rest]) do
    count_contiguous_segments(rest, first, 1)
  end

  defp count_contiguous_segments([], _prev, count), do: count

  defp count_contiguous_segments([current | rest], prev, count) do
    if current == prev + 1 do
      # Contiguous, same segment
      count_contiguous_segments(rest, current, count)
    else
      # Gap, new segment
      count_contiguous_segments(rest, current, count + 1)
    end
  end
end
