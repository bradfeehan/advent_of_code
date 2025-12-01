defmodule Year2024.Day08.Part2 do
  @moduledoc """
  Part 2 — Day 8: Resonant Collinearity

  Finds antinodes: points at ANY position exactly in line with at least two antennas
  of the same frequency, regardless of distance. This includes all points on the line
  that passes through any pair of same-frequency antennas.
  """

  @doc """
  Solves part 2 of Day 8.

  Returns the count of unique locations within the bounds of the map that contain an antinode.
  """
  @spec solve(String.t()) :: integer()
  def solve(input) do
    lines = input |> String.trim() |> String.split("\n", trim: true)
    num_rows = length(lines)
    num_cols = if num_rows > 0, do: String.length(Enum.at(lines, 0)), else: 0

    input
    |> parse_antennas()
    |> find_all_antinodes(num_rows, num_cols)
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

  For each pair of antennas, finds all points on the line that passes through them,
  extending in both directions within bounds.
  """
  @spec find_all_antinodes(%{char() => [{integer(), integer()}]}, integer(), integer()) :: [{integer(), integer()}]
  def find_all_antinodes(antennas_by_frequency, num_rows, num_cols) do
    antennas_by_frequency
    |> Enum.flat_map(fn {_frequency, positions} ->
      find_antinodes_for_frequency(positions, num_rows, num_cols)
    end)
  end

  defp find_antinodes_for_frequency(positions, num_rows, num_cols) do
    positions
    |> combinations(2)
    |> Enum.flat_map(fn [a1, a2] ->
      points_on_line(a1, a2, num_rows, num_cols)
    end)
  end

  defp points_on_line({r1, c1}, {r2, c2}, num_rows, num_cols) do
    dr = r2 - r1
    dc = c2 - c1

    # Normalize direction vector by GCD to get unit step
    # Handle the case where both dr and dc are 0 (shouldn't happen for different points)
    {unit_dr, unit_dc} =
      if dr == 0 and dc == 0 do
        {0, 0}
      else
        gcd = Integer.gcd(abs(dr), abs(dc))
        {div(dr, gcd), div(dc, gcd)}
      end

    # Generate all points on the line: a1 + k * unit_vector for all integers k
    # We need to find the range of k that keeps us in bounds
    # Start from a large negative k and go to a large positive k
    # Filter to points within bounds
    Stream.iterate(-max(num_rows, num_cols), &(&1 + 1))
    |> Stream.take(2 * max(num_rows, num_cols) + 1)
    |> Enum.map(fn k ->
      {r1 + k * unit_dr, c1 + k * unit_dc}
    end)
    |> Enum.filter(fn {r, c} ->
      r >= 0 and r < num_rows and c >= 0 and c < num_cols
    end)
  end

  defp combinations(_list, 0), do: [[]]
  defp combinations([], _n), do: []
  defp combinations([head | tail], n) do
    combinations(tail, n - 1)
    |> Enum.map(&[head | &1])
    |> Kernel.++(combinations(tail, n))
  end
end
