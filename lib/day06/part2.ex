defmodule Day06.Part2 do
  @moduledoc """
  Part 2 — Day 6: Guard Gallivant

  Finds all positions where placing a new obstruction would cause the guard
  to get stuck in a loop. Only positions on the original patrol path (excluding
  the starting position) need to be checked.
  """

  @type position :: {integer(), integer()}
  @type direction :: :up | :down | :left | :right
  @type state :: {position(), direction()}

  @doc """
  Solves part 2 by finding all positions where an obstruction creates a loop.
  """
  @spec solve(String.t()) :: integer()
  def solve(input) do
    {obstructions, guard_pos, guard_dir, bounds} = parse_map(input)

    # Get the original patrol path (excluding starting position)
    original_path =
      get_patrol_path(guard_pos, guard_dir, obstructions, bounds)
      |> MapSet.delete(guard_pos)

    # Check each position on the path to see if adding an obstruction creates a loop
    original_path
    |> Enum.count(fn candidate_pos ->
      new_obstructions = MapSet.put(obstructions, candidate_pos)
      creates_loop?(guard_pos, guard_dir, new_obstructions, bounds)
    end)
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

  @spec get_patrol_path(position(), direction(), MapSet.t(position()), {integer(), integer()}) :: MapSet.t(position())
  defp get_patrol_path(pos, dir, obstructions, bounds) do
    simulate_path(pos, dir, obstructions, bounds, MapSet.new([pos]))
  end

  @spec simulate_path(position(), direction(), MapSet.t(position()), {integer(), integer()}, MapSet.t(position())) :: MapSet.t(position())
  defp simulate_path({row, col}, direction, obstructions, {height, width} = bounds, visited) do
    next_pos = next_position({row, col}, direction)
    {next_row, next_col} = next_pos

    cond do
      next_row < 0 or next_row >= height or next_col < 0 or next_col >= width ->
        visited

      MapSet.member?(obstructions, next_pos) ->
        simulate_path({row, col}, turn_right(direction), obstructions, bounds, visited)

      true ->
        simulate_path(next_pos, direction, obstructions, bounds, MapSet.put(visited, next_pos))
    end
  end

  @spec creates_loop?(position(), direction(), MapSet.t(position()), {integer(), integer()}) :: boolean()
  defp creates_loop?(pos, dir, obstructions, bounds) do
    detect_loop(pos, dir, obstructions, bounds, MapSet.new([{pos, dir}]))
  end

  @spec detect_loop(position(), direction(), MapSet.t(position()), {integer(), integer()}, MapSet.t(state())) :: boolean()
  defp detect_loop({row, col}, direction, obstructions, {height, width} = bounds, seen_states) do
    next_pos = next_position({row, col}, direction)
    {next_row, next_col} = next_pos

    cond do
      # Guard left the map - no loop
      next_row < 0 or next_row >= height or next_col < 0 or next_col >= width ->
        false

      # Obstruction ahead - turn right
      MapSet.member?(obstructions, next_pos) ->
        new_dir = turn_right(direction)
        new_state = {{row, col}, new_dir}

        if MapSet.member?(seen_states, new_state) do
          true
        else
          detect_loop({row, col}, new_dir, obstructions, bounds, MapSet.put(seen_states, new_state))
        end

      # Move forward
      true ->
        new_state = {next_pos, direction}

        if MapSet.member?(seen_states, new_state) do
          true
        else
          detect_loop(next_pos, direction, obstructions, bounds, MapSet.put(seen_states, new_state))
        end
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
