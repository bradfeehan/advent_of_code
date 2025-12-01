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
  def safe?(%__MODULE__{levels: levels}) do
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
