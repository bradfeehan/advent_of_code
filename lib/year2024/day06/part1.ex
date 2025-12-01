defmodule Year2024.Day06.Part1 do
  @moduledoc """
  Part 1 — Day 6: Guard Gallivant

  Simulates a guard patrolling a lab following a strict protocol:
  - If there's an obstruction directly ahead, turn right 90 degrees
  - Otherwise, take a step forward

  Counts the distinct positions visited before the guard leaves the map.
  """

  @type position :: {integer(), integer()}
  @type direction :: :up | :down | :left | :right

  @doc """
  Solves part 1 by simulating the guard's patrol and counting visited positions.
  """
  @spec solve(String.t()) :: integer()
  def solve(input) do
    {obstructions, guard_pos, guard_dir, bounds} = parse_map(input)

    simulate(guard_pos, guard_dir, obstructions, bounds, MapSet.new([guard_pos]))
    |> MapSet.size()
  end

  @spec parse_map(String.t()) :: {MapSet.t(position()), position(), direction(), {integer(), integer()}}
  defp parse_map(input) do
    lines = input |> String.trim() |> String.split("\n")
    height = length(lines)
    width = lines |> hd() |> String.length()

    {obstructions, guard_pos, guard_dir} =
      lines
      |> Enum.with_index()
      |> Enum.reduce({MapSet.new(), nil, nil}, fn {line, row}, acc ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {char, col}, {obs, pos, dir} ->
          case char do
            "#" -> {MapSet.put(obs, {row, col}), pos, dir}
            "^" -> {obs, {row, col}, :up}
            "v" -> {obs, {row, col}, :down}
            "<" -> {obs, {row, col}, :left}
            ">" -> {obs, {row, col}, :right}
            _ -> {obs, pos, dir}
          end
        end)
      end)

    {obstructions, guard_pos, guard_dir, {height, width}}
  end

  @spec simulate(position(), direction(), MapSet.t(position()), {integer(), integer()}, MapSet.t(position())) :: MapSet.t(position())
  defp simulate({row, col}, direction, obstructions, {height, width} = bounds, visited) do
    next_pos = next_position({row, col}, direction)
    {next_row, next_col} = next_pos

    cond do
      # Guard has left the map
      next_row < 0 or next_row >= height or next_col < 0 or next_col >= width ->
        visited

      # There's an obstruction ahead, turn right
      MapSet.member?(obstructions, next_pos) ->
        simulate({row, col}, turn_right(direction), obstructions, bounds, visited)

      # Move forward
      true ->
        simulate(next_pos, direction, obstructions, bounds, MapSet.put(visited, next_pos))
    end
  end

  @spec next_position(position(), direction()) :: position()
  defp next_position({row, col}, :up), do: {row - 1, col}
  defp next_position({row, col}, :down), do: {row + 1, col}
  defp next_position({row, col}, :left), do: {row, col - 1}
  defp next_position({row, col}, :right), do: {row, col + 1}

  @spec turn_right(direction()) :: direction()
  defp turn_right(:up), do: :right
  defp turn_right(:right), do: :down
  defp turn_right(:down), do: :left
  defp turn_right(:left), do: :up
end
