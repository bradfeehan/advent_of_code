defmodule Year2024.Day06.Part2 do
  @moduledoc """
  Part 2 — Day 6: Guard Gallivant

  Uses ray-casting with sorted obstruction lists for O(log n) jumps instead of O(n) step-by-step.
  """

  @spec solve(String.t()) :: integer()
  def solve(input) do
    {obstructions, guard_pos, guard_dir, {height, width}} = parse_map(input)

    # Build sorted obstruction indices for fast ray casting
    # For each row: sorted list of columns with obstructions
    # For each col: sorted list of rows with obstructions
    obs_by_row = build_obs_by_row(obstructions, height)
    obs_by_col = build_obs_by_col(obstructions, width)

    # Get original patrol path
    original_path =
      get_patrol_path_fast(guard_pos, guard_dir, obs_by_row, obs_by_col, height, width)
      |> MapSet.delete(guard_pos)

    # Check each candidate in parallel
    original_path
    |> Task.async_stream(
      fn candidate_pos ->
        creates_loop_fast?(
          guard_pos,
          guard_dir,
          candidate_pos,
          obs_by_row,
          obs_by_col,
          height,
          width
        )
      end,
      ordered: false,
      timeout: :infinity
    )
    |> Enum.count(fn {:ok, result} -> result end)
  end

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
            "^" -> {obs, {row, col}, 0}
            ">" -> {obs, {row, col}, 1}
            "v" -> {obs, {row, col}, 2}
            "<" -> {obs, {row, col}, 3}
            _ -> {obs, pos, dir}
          end
        end)
      end)

    {obstructions, guard_pos, guard_dir, {height, width}}
  end

  # Build tuple of sorted column indices for each row
  defp build_obs_by_row(obstructions, height) do
    base = for _ <- 0..(height - 1), do: []

    obstructions
    |> Enum.reduce(base, fn {row, col}, acc ->
      List.update_at(acc, row, &[col | &1])
    end)
    |> Enum.map(&Enum.sort/1)
    |> List.to_tuple()
  end

  # Build tuple of sorted row indices for each column
  defp build_obs_by_col(obstructions, width) do
    base = for _ <- 0..(width - 1), do: []

    obstructions
    |> Enum.reduce(base, fn {row, col}, acc ->
      List.update_at(acc, col, &[row | &1])
    end)
    |> Enum.map(&Enum.sort/1)
    |> List.to_tuple()
  end

  # Find next obstruction in direction, return stop position or :exit
  # Returns {stop_row, stop_col} or :exit
  defp ray_cast({row, col}, dir, obs_by_row, obs_by_col, _height, _width, extra_obs) do
    case dir do
      # up: find largest row < current row in this column
      0 ->
        candidates = elem(obs_by_col, col)

        candidates =
          if extra_obs && elem(extra_obs, 1) == col,
            do: insert_sorted(candidates, elem(extra_obs, 0)),
            else: candidates

        case find_prev(candidates, row) do
          nil -> :exit
          obs_row -> {obs_row + 1, col}
        end

      # right: find smallest col > current col in this row
      1 ->
        candidates = elem(obs_by_row, row)

        candidates =
          if extra_obs && elem(extra_obs, 0) == row,
            do: insert_sorted(candidates, elem(extra_obs, 1)),
            else: candidates

        case find_next(candidates, col) do
          nil -> :exit
          obs_col -> {row, obs_col - 1}
        end

      # down: find smallest row > current row in this column
      2 ->
        candidates = elem(obs_by_col, col)

        candidates =
          if extra_obs && elem(extra_obs, 1) == col,
            do: insert_sorted(candidates, elem(extra_obs, 0)),
            else: candidates

        case find_next(candidates, row) do
          nil -> :exit
          obs_row -> {obs_row - 1, col}
        end

      # left: find largest col < current col in this row
      3 ->
        candidates = elem(obs_by_row, row)

        candidates =
          if extra_obs && elem(extra_obs, 0) == row,
            do: insert_sorted(candidates, elem(extra_obs, 1)),
            else: candidates

        case find_prev(candidates, col) do
          nil -> :exit
          obs_col -> {row, obs_col + 1}
        end
    end
  end

  # Find largest value < target in sorted list
  defp find_prev([], _target), do: nil

  defp find_prev(list, target) do
    case Enum.take_while(list, &(&1 < target)) do
      [] -> nil
      prev -> List.last(prev)
    end
  end

  # Find smallest value > target in sorted list
  defp find_next([], _target), do: nil

  defp find_next(list, target) do
    case Enum.drop_while(list, &(&1 <= target)) do
      [] -> nil
      [next | _] -> next
    end
  end

  defp insert_sorted(list, val) do
    {before, after_} = Enum.split_while(list, &(&1 < val))
    before ++ [val | after_]
  end

  defp get_patrol_path_fast({row, col}, dir, obs_by_row, obs_by_col, height, width) do
    do_patrol_fast(
      {row, col},
      dir,
      obs_by_row,
      obs_by_col,
      height,
      width,
      nil,
      MapSet.new([{row, col}])
    )
  end

  defp do_patrol_fast({row, col}, dir, obs_by_row, obs_by_col, height, width, extra_obs, visited) do
    case ray_cast({row, col}, dir, obs_by_row, obs_by_col, height, width, extra_obs) do
      :exit ->
        # Add all positions from current to edge
        add_path_to_edge({row, col}, dir, height, width, visited)

      {stop_row, stop_col} ->
        # Add all positions from current to stop
        new_visited = add_path({row, col}, {stop_row, stop_col}, dir, visited)
        new_dir = rem(dir + 1, 4)

        do_patrol_fast(
          {stop_row, stop_col},
          new_dir,
          obs_by_row,
          obs_by_col,
          height,
          width,
          extra_obs,
          new_visited
        )
    end
  end

  defp add_path({r1, c1}, {r2, c2}, dir, visited) do
    case dir do
      0 -> Enum.reduce(r2..r1, visited, &MapSet.put(&2, {&1, c1}))
      1 -> Enum.reduce(c1..c2, visited, &MapSet.put(&2, {r1, &1}))
      2 -> Enum.reduce(r1..r2, visited, &MapSet.put(&2, {&1, c1}))
      3 -> Enum.reduce(c2..c1, visited, &MapSet.put(&2, {r1, &1}))
    end
  end

  defp add_path_to_edge({row, col}, dir, height, width, visited) do
    case dir do
      0 -> Enum.reduce(0..row, visited, &MapSet.put(&2, {&1, col}))
      1 -> Enum.reduce(col..(width - 1), visited, &MapSet.put(&2, {row, &1}))
      2 -> Enum.reduce(row..(height - 1), visited, &MapSet.put(&2, {&1, col}))
      3 -> Enum.reduce(0..col, visited, &MapSet.put(&2, {row, &1}))
    end
  end

  defp creates_loop_fast?({row, col}, dir, new_obs, obs_by_row, obs_by_col, height, width) do
    detect_loop_fast(
      {row, col},
      dir,
      new_obs,
      obs_by_row,
      obs_by_col,
      height,
      width,
      MapSet.new()
    )
  end

  defp detect_loop_fast({row, col}, dir, new_obs, obs_by_row, obs_by_col, height, width, seen) do
    state = {row, col, dir}

    if MapSet.member?(seen, state) do
      true
    else
      new_seen = MapSet.put(seen, state)

      case ray_cast({row, col}, dir, obs_by_row, obs_by_col, height, width, new_obs) do
        :exit ->
          false

        {stop_row, stop_col} ->
          new_dir = rem(dir + 1, 4)

          detect_loop_fast(
            {stop_row, stop_col},
            new_dir,
            new_obs,
            obs_by_row,
            obs_by_col,
            height,
            width,
            new_seen
          )
      end
    end
  end
end
