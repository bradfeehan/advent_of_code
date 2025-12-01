defmodule Year2024.Day13.Parser do
  @moduledoc """
  Shared parsing logic for Day 13: Claw Contraption
  """

  @type machine :: %{
          ax: integer(),
          ay: integer(),
          bx: integer(),
          by: integer(),
          px: integer(),
          py: integer()
        }

  @doc """
  Parse input into a list of machine configurations.
  Optionally apply an offset to prize coordinates.
  """
  @spec parse_machines(String.t(), integer()) :: [machine()]
  def parse_machines(input, prize_offset \\ 0) do
    input
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&parse_machine(&1, prize_offset))
  end

  defp parse_machine(block, prize_offset) do
    lines = String.split(block, "\n")

    [ax, ay] = parse_button(Enum.at(lines, 0))
    [bx, by] = parse_button(Enum.at(lines, 1))
    [px, py] = parse_prize(Enum.at(lines, 2))

    %{ax: ax, ay: ay, bx: bx, by: by, px: px + prize_offset, py: py + prize_offset}
  end

  defp parse_button(line) do
    Regex.scan(~r/[XY]\+(\d+)/, line)
    |> Enum.map(fn [_, n] -> String.to_integer(n) end)
  end

  defp parse_prize(line) do
    Regex.scan(~r/[XY]=(\d+)/, line)
    |> Enum.map(fn [_, n] -> String.to_integer(n) end)
  end
end
