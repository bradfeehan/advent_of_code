defmodule Year2024.Day08.Part1 do
  @moduledoc """
  Part 1 — Day 8: Resonant Collinearity

  Finds antinodes: points perfectly in line with two antennas of the same frequency,
  where one antenna is twice as far away as the other. For each pair of same-frequency
  antennas, there are two antinodes (one on each side).
  """

  @doc """
  Solves part 1 of Day 8.

  Returns the count of unique locations within the bounds of the map that contain an antinode.
  """
  @spec solve(String.t()) :: integer()
  def solve(input) do
    input
    |> parse_antennas()
    |> find_all_antinodes()
    |> Enum.filter(&within_bounds?(&1, input))
    |> Enum.uniq()
    |> length()
  end

  @doc """
  Parses the input to find all antennas and their positions.

  Returns a map where keys are frequencies (characters) and values are lists of {row, col} positions.
  """
  @spec parse_antennas(String.t()) :: %{char() => [{integer(), integer()}]}
  def parse_antennas(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, row}, acc ->
      line
      |> String.to_charlist()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn
        {?., _col}, acc -> acc
        {frequency, col}, acc ->
          Map.update(acc, frequency, [{row, col}], fn positions ->
            [{row, col} | positions]
          end)
      end)
    end)
  end

  @doc """
  Finds all antinodes for all pairs of antennas with the same frequency.

  For each pair of antennas at positions a1 and a2, calculates two antinodes:
  - antinode1 = 2*a1 - a2 (on one side)
  - antinode2 = 2*a2 - a1 (on the other side)
  """
  @spec find_all_antinodes(%{char() => [{integer(), integer()}]}) :: [{integer(), integer()}]
  def find_all_antinodes(antennas_by_frequency) do
    antennas_by_frequency
    |> Enum.flat_map(fn {_frequency, positions} ->
      find_antinodes_for_frequency(positions)
    end)
  end

  defp find_antinodes_for_frequency(positions) do
    positions
    |> combinations(2)
    |> Enum.flat_map(fn [a1, a2] ->
      [
        antinode_position(a1, a2),
        antinode_position(a2, a1)
      ]
    end)
  end

  defp antinode_position(a1, a2) do
    {r1, c1} = a1
    {r2, c2} = a2
    {2 * r1 - r2, 2 * c1 - c2}
  end

  defp combinations(_list, 0), do: [[]]
  defp combinations([], _n), do: []
  defp combinations([head | tail], n) do
    combinations(tail, n - 1)
    |> Enum.map(&[head | &1])
    |> Kernel.++(combinations(tail, n))
  end

  defp within_bounds?({row, col}, input) do
    lines = input |> String.trim() |> String.split("\n", trim: true)
    num_rows = length(lines)
    num_cols = if num_rows > 0, do: String.length(Enum.at(lines, 0)), else: 0

    row >= 0 and row < num_rows and col >= 0 and col < num_cols
  end
end
