defmodule Year2024.Day09.Part2 do
  @moduledoc """
  Part 2 — Day 9: Disk Fragmenter

  Compacts a fragmented disk by moving whole files (instead of individual blocks)
  to the leftmost free space span that fits, processing files in decreasing order
  of file ID, then calculates the filesystem checksum.
  """

  @doc """
  Solves part 2 of Day 9.

  Parses the disk map, compacts the disk by moving whole files, and returns
  the filesystem checksum.
  """
  @spec solve(String.t()) :: integer()
  def solve(input) do
    input
    |> String.trim()
    |> parse_disk_map()
    |> build_initial_layout()
    |> compact_files()
    |> calculate_checksum()
  end

  @doc """
  Parses the disk map string into a list of {file_length, free_space_length} tuples.

  The disk map alternates between file lengths and free space lengths.
  """
  @spec parse_disk_map(String.t()) :: [{integer(), integer()}]
  def parse_disk_map(map_string) do
    map_string
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.map(fn
      [file_len, free_len] -> {file_len, free_len}
      [file_len] -> {file_len, 0}
    end)
  end

  @doc """
  Builds the initial disk layout from parsed segments.

  Returns a list where each element is either a file ID (integer) or `:free` (atom).
  """
  @spec build_initial_layout([{integer(), integer()}]) :: [integer() | :free]
  def build_initial_layout(segments) do
    segments
    |> Enum.with_index()
    |> Enum.flat_map(fn {{file_len, free_len}, file_id} ->
      List.duplicate(file_id, file_len) ++ List.duplicate(:free, free_len)
    end)
  end

  @doc """
  Compacts the disk by moving whole files to the leftmost free space span.

  Processes files in decreasing order of file ID (highest first).
  Each file is moved exactly once to the leftmost free space span that fits
  and is to the left of the file.
  """
  @spec compact_files([integer() | :free]) :: [integer() | :free]
  def compact_files(disk) do
    file_ids = get_file_ids(disk) |> Enum.sort(:desc)

    Enum.reduce(file_ids, disk, fn file_id, acc ->
      move_file_if_possible(acc, file_id)
    end)
  end

  @doc """
  Gets all unique file IDs from the disk.
  """
  @spec get_file_ids([integer() | :free]) :: [integer()]
  def get_file_ids(disk) do
    disk
    |> Enum.uniq()
    |> Enum.filter(&is_integer/1)
  end

  @doc """
  Moves a file to the leftmost free space span that fits, if possible.

  Returns the disk unchanged if no suitable free space is found to the left.
  """
  @spec move_file_if_possible([integer() | :free], integer()) :: [integer() | :free]
  def move_file_if_possible(disk, file_id) do
    {file_start, file_end} = find_file_range(disk, file_id)

    # If file not found (shouldn't happen, but handle gracefully)
    if file_start == nil or file_end == nil do
      disk
    else
      file_size = file_end - file_start + 1

      case find_leftmost_free_span(disk, file_size, file_start) do
        nil -> disk
        {free_start, _free_end} ->
          move_file(disk, file_start, file_end, free_start)
      end
    end
  end

  @doc """
  Finds the position range of a file in the disk.

  Returns `{start_pos, end_pos}` where both positions are inclusive.
  """
  @spec find_file_range([integer() | :free], integer()) :: {integer(), integer()}
  def find_file_range(disk, file_id) do
    case Enum.find(disk |> Enum.with_index(), fn {block, _pos} -> block == file_id end) do
      nil -> {nil, nil}
      {_block, start_pos} ->
        case disk
             |> Enum.with_index()
             |> Enum.reverse()
             |> Enum.find(fn {block, _pos} -> block == file_id end) do
          nil -> {start_pos, start_pos}
          {_block, end_pos} -> {start_pos, end_pos}
        end
    end
  end

  @doc """
  Finds the leftmost free space span that's large enough and to the left of a position.

  Returns `{start_pos, end_pos}` if found, `nil` otherwise.
  """
  @spec find_leftmost_free_span([integer() | :free], integer(), integer()) :: {integer(), integer()} | nil
  def find_leftmost_free_span(disk, required_size, max_pos) do
    disk
    |> Enum.with_index()
    |> Enum.take(max_pos)
    |> find_contiguous_free_span(required_size)
  end

  @doc """
  Finds the leftmost contiguous free space span of at least the required size.

  Returns `{start_pos, end_pos}` if found, `nil` otherwise.
  """
  @spec find_contiguous_free_span([{integer() | :free, integer()}], integer()) :: {integer(), integer()} | nil
  def find_contiguous_free_span(disk_with_positions, required_size) do
    find_contiguous_free_span(disk_with_positions, required_size, nil, 0)
  end

  defp find_contiguous_free_span([], _required_size, _current_start, _current_length), do: nil

  defp find_contiguous_free_span([{:free, pos} | rest], required_size, current_start, current_length) do
    new_start = current_start || pos
    new_length = current_length + 1

    if new_length >= required_size do
      {new_start, new_start + new_length - 1}
    else
      find_contiguous_free_span(rest, required_size, new_start, new_length)
    end
  end

  defp find_contiguous_free_span([{_block, _pos} | rest], required_size, _current_start, _current_length) do
    find_contiguous_free_span(rest, required_size, nil, 0)
  end

  @doc """
  Moves a file from one range to another.

  The source range becomes free space, and the destination range gets the file blocks.
  """
  @spec move_file([integer() | :free], integer(), integer(), integer()) :: [integer() | :free]
  def move_file(disk, file_start, file_end, free_start) do
    file_id = Enum.at(disk, file_start)
    file_size = file_end - file_start + 1

    disk
    |> clear_range(file_start, file_end)
    |> fill_range(free_start, file_size, file_id)
  end

  @doc """
  Clears a range of positions, making them free space.
  """
  @spec clear_range([integer() | :free], integer(), integer()) :: [integer() | :free]
  def clear_range(disk, start_pos, end_pos) do
    Enum.reduce(start_pos..end_pos, disk, fn pos, acc ->
      List.replace_at(acc, pos, :free)
    end)
  end

  @doc """
  Fills a range of positions with a file ID.
  """
  @spec fill_range([integer() | :free], integer(), integer(), integer()) :: [integer() | :free]
  def fill_range(disk, start_pos, size, file_id) do
    Enum.reduce(0..(size - 1)//1, disk, fn offset, acc ->
      pos = start_pos + offset
      List.replace_at(acc, pos, file_id)
    end)
  end

  @doc """
  Calculates the filesystem checksum.

  Sums (position * file_id) for all file blocks (skipping free space).
  """
  @spec calculate_checksum([integer() | :free]) :: integer()
  def calculate_checksum(disk) do
    disk
    |> Enum.with_index()
    |> Enum.reduce(0, fn
      {:free, _pos}, acc -> acc
      {file_id, pos}, acc -> acc + pos * file_id
    end)
  end
end
