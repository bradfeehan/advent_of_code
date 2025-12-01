defmodule Day02.Report do
  @moduledoc """
  A reactor safety report containing a sequence of levels.
  """

  @enforce_keys [:levels]
  defstruct [:levels]

  @type t :: %__MODULE__{
          levels: [integer()]
        }

  @doc """
  Creates a new Report from a space-separated string of integers.
  """
  @spec parse(String.t()) :: t()
  def parse(line) do
    levels =
      line
      |> String.split(~r/\s+/, trim: true)
      |> Enum.map(&String.to_integer/1)

    %__MODULE__{levels: levels}
  end

  @doc """
  Determines if the report is safe.

  A report is safe if levels are monotonically increasing or decreasing,
  and each adjacent pair differs by 1-3.
  """
  @spec safe?(t()) :: boolean()
  def safe?(%__MODULE__{levels: levels}), do: safe_levels?(levels)

  @doc """
  Determines if the report is safe with the Problem Dampener.

  The dampener allows tolerating a single bad level - if removing any one
  level would make the report safe, it counts as safe.
  """
  @spec safe_with_dampener?(t()) :: boolean()
  def safe_with_dampener?(%__MODULE__{levels: levels}) do
    safe_levels?(levels) or
      levels
      |> subsequences()
      |> Enum.any?(&safe_levels?/1)
  end

  # Returns all subsequences of length n-1.
  # A subsequence is a sequence derived by deleting one element without
  # changing the order of remaining elements.
  # e.g. [1,2,3] -> [[2,3], [1,3], [1,2]]
  @spec subsequences([integer()]) :: [[integer()]]
  defp subsequences(levels) do
    for i <- 0..(length(levels) - 1), do: List.delete_at(levels, i)
  end

  @spec safe_levels?([integer()]) :: boolean()
  defp safe_levels?(levels) do
    differences = compute_differences(levels)

    all_increasing?(differences) or all_decreasing?(differences)
  end

  @spec compute_differences([integer()]) :: [integer()]
  defp compute_differences(levels) do
    levels
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] -> b - a end)
  end

  @spec all_increasing?([integer()]) :: boolean()
  defp all_increasing?(differences), do: Enum.all?(differences, &(&1 >= 1 and &1 <= 3))

  @spec all_decreasing?([integer()]) :: boolean()
  defp all_decreasing?(differences), do: Enum.all?(differences, &(&1 >= -3 and &1 <= -1))
end
