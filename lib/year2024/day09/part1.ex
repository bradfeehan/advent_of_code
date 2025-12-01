defmodule Year2024.Day09.Part1 do
  @moduledoc """
  Part 1 — Day 9: Disk Fragmenter

  Compacts a fragmented disk by moving file blocks from the end to the leftmost
  free space, then calculates the filesystem checksum.
  """

  @doc """
  Solves part 1 of Day 9.

  Parses the disk map, compacts the disk, and returns the filesystem checksum.
  """
  @spec solve(String.t()) :: integer()
  def solve(input) do
    input
    |> String.trim()
    |> parse_disk_map()
    |> build_initial_layout()
    |> compact()
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
  Compacts the disk by moving file blocks from the end to the leftmost free space.

  Repeatedly finds the rightmost file block and moves it to the leftmost free space
  until no more moves are possible.
  """
  @spec compact([integer() | :free]) :: [integer() | :free]
  def compact(disk) do
    case find_move(disk) do
      nil -> disk
      {from_pos, to_pos} ->
        disk
        |> move_block(from_pos, to_pos)
        |> compact()
    end
  end

  @doc """
  Finds the next move: rightmost file block to leftmost free space.

  Returns `{from_pos, to_pos}` if a move is possible, `nil` otherwise.
  """
  @spec find_move([integer() | :free]) :: {integer(), integer()} | nil
  def find_move(disk) do
    # Find rightmost file block (non-:free)
    from_pos =
      disk
      |> Enum.with_index()
      |> Enum.reverse()
      |> Enum.find_value(fn {block, pos} -> if block != :free, do: pos end)

    # Find leftmost free space
    to_pos =
      disk
      |> Enum.find_index(&(&1 == :free))

    if from_pos != nil and to_pos != nil and from_pos > to_pos do
      {from_pos, to_pos}
    else
      nil
    end
  end

  @doc """
  Moves a block from one position to another.

  The source position becomes free space, and the destination gets the file block.
  """
  @spec move_block([integer() | :free], integer(), integer()) :: [integer() | :free]
  def move_block(disk, from_pos, to_pos) do
    block = Enum.at(disk, from_pos)

    disk
    |> List.replace_at(from_pos, :free)
    |> List.replace_at(to_pos, block)
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
