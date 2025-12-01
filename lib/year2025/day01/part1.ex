defmodule Year2025.Day01.Part1 do
  @moduledoc """
  Part 1 — Day 1: Secret Entrance

  The dial starts at 50 and rotates left (L) or right (R) by a given amount.
  The dial wraps around from 0-99.
  We count how many times the dial ends up pointing at 0 after any rotation.
  """

  @initial_position 50
  @dial_size 100

  @spec solve(String.t()) :: non_neg_integer()
  def solve(input) do
    input
    |> parse_rotations()
    |> follow_rotations()
    |> count_zeros()
  end

  defp parse_rotations(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_rotation/1)
  end

  defp parse_rotation(<<"L", distance::binary>>), do: {:left, String.to_integer(distance)}
  defp parse_rotation(<<"R", distance::binary>>), do: {:right, String.to_integer(distance)}

  defp follow_rotations(rotations) do
    Enum.scan(rotations, @initial_position, &apply_rotation/2)
  end

  defp apply_rotation({:left, dist}, pos), do: Integer.mod(pos - dist, @dial_size)
  defp apply_rotation({:right, dist}, pos), do: Integer.mod(pos + dist, @dial_size)

  defp count_zeros(positions) do
    Enum.count(positions, &(&1 == 0))
  end
end
