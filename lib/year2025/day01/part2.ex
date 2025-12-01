defmodule Year2025.Day01.Part2 do
  @moduledoc """
  Part 2 — Day 1: Secret Entrance

  Count every click that causes the dial to point at 0, including during rotations.
  For example, R1000 from position 50 would pass through 0 ten times.
  """

  @initial_position 50
  @dial_size 100

  @spec solve(String.t()) :: non_neg_integer()
  def solve(input) do
    input
    |> parse_rotations()
    |> count_all_zeros()
  end

  defp parse_rotations(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_rotation/1)
  end

  defp parse_rotation(<<"L", distance::binary>>), do: {:left, String.to_integer(distance)}
  defp parse_rotation(<<"R", distance::binary>>), do: {:right, String.to_integer(distance)}

  defp count_all_zeros(rotations) do
    {total_zeros, _final_pos} =
      Enum.reduce(rotations, {0, @initial_position}, fn rotation, {zeros, pos} ->
        new_zeros = zeros + count_zeros_in_rotation(rotation, pos)
        new_pos = apply_rotation(rotation, pos)
        {new_zeros, new_pos}
      end)

    total_zeros
  end

  # For RIGHT: count multiples of 100 in range (pos, pos + dist]
  defp count_zeros_in_rotation({:right, dist}, pos) do
    div(pos + dist, @dial_size) - div(pos, @dial_size)
  end

  # For LEFT: count multiples of 100 in range [pos - dist, pos)
  # Using floor division to handle negative numbers correctly
  defp count_zeros_in_rotation({:left, dist}, pos) do
    Integer.floor_div(pos - 1, @dial_size) - Integer.floor_div(pos - 1 - dist, @dial_size)
  end

  defp apply_rotation({:left, dist}, pos), do: Integer.mod(pos - dist, @dial_size)
  defp apply_rotation({:right, dist}, pos), do: Integer.mod(pos + dist, @dial_size)
end
