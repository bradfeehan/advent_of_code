defmodule Year2024.Day12.Part1 do
  @moduledoc """
  Part 1 — Day 12: Garden Groups

  Calculates the total price of fencing all garden regions on the map.
  Each region's price is its area multiplied by its perimeter.
  """

  @type position :: {integer(), integer()}
  @type grid :: %{position() => char()}

  @doc """
  Solves part 1 by finding all regions and calculating total fence price.
  """
  @spec solve(String.t()) :: integer()
  def solve(input) do
    grid = parse(input)

    grid
    |> find_all_regions()
    |> Enum.map(&region_price(&1, grid))
    |> Enum.sum()
  end

  @doc """
  Parses the input string into a grid map of positions to characters.
  """
  @spec parse(String.t()) :: grid()
  def parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, row}, acc ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {char, col}, inner_acc ->
        Map.put(inner_acc, {row, col}, char)
      end)
    end)
  end

  @doc """
  Finds all distinct regions in the grid using flood fill.
  Returns a list of MapSets, each containing the positions of one region.
  """
  @spec find_all_regions(grid()) :: [MapSet.t(position())]
  def find_all_regions(grid) do
    positions = Map.keys(grid)
    find_all_regions(grid, positions, MapSet.new(), [])
  end

  defp find_all_regions(_grid, [], _visited, regions), do: regions

  defp find_all_regions(grid, [pos | rest], visited, regions) do
    if MapSet.member?(visited, pos) do
      find_all_regions(grid, rest, visited, regions)
    else
      region = flood_fill(grid, pos)
      new_visited = MapSet.union(visited, region)
      find_all_regions(grid, rest, new_visited, [region | regions])
    end
  end

  @doc """
  Performs flood fill from a starting position to find all connected positions
  with the same plant type.
  """
  @spec flood_fill(grid(), position()) :: MapSet.t(position())
  def flood_fill(grid, start_pos) do
    plant_type = Map.get(grid, start_pos)
    flood_fill(grid, [start_pos], plant_type, MapSet.new())
  end

  defp flood_fill(_grid, [], _plant_type, region), do: region

  defp flood_fill(grid, [pos | rest], plant_type, region) do
    if MapSet.member?(region, pos) do
      flood_fill(grid, rest, plant_type, region)
    else
      case Map.get(grid, pos) do
        ^plant_type ->
          new_region = MapSet.put(region, pos)
          neighbors = get_neighbors(pos)
          flood_fill(grid, neighbors ++ rest, plant_type, new_region)

        _ ->
          flood_fill(grid, rest, plant_type, region)
      end
    end
  end

  @doc """
  Gets the four orthogonal neighbors of a position.
  """
  @spec get_neighbors(position()) :: [position()]
  def get_neighbors({row, col}) do
    [
      {row - 1, col},
      {row + 1, col},
      {row, col - 1},
      {row, col + 1}
    ]
  end

  @doc """
  Calculates the fence price for a region (area * perimeter).
  """
  @spec region_price(MapSet.t(position()), grid()) :: integer()
  def region_price(region, grid) do
    area = region_area(region)
    perimeter = region_perimeter(region, grid)
    area * perimeter
  end

  @doc """
  Returns the area of a region (number of positions in the region).
  """
  @spec region_area(MapSet.t(position())) :: integer()
  def region_area(region) do
    MapSet.size(region)
  end

  @doc """
  Calculates the perimeter of a region.
  A side contributes to the perimeter if it doesn't touch another
  plot in the same region.
  """
  @spec region_perimeter(MapSet.t(position()), grid()) :: integer()
  def region_perimeter(region, _grid) do
    region
    |> Enum.map(fn pos ->
      pos
      |> get_neighbors()
      |> Enum.count(&(not MapSet.member?(region, &1)))
    end)
    |> Enum.sum()
  end
end
