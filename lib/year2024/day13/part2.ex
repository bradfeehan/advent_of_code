defmodule Year2024.Day13.Part2 do
  @moduledoc """
  Part 2 — Day 13: Claw Contraption

  Same as Part 1, but prize coordinates are offset by 10000000000000
  and there is no 100-press limit.
  """

  alias Year2024.Day13.Parser

  @offset 10_000_000_000_000

  @spec solve(String.t()) :: integer()
  def solve(input) do
    input
    |> Parser.parse_machines(@offset)
    |> Enum.map(&solve_machine/1)
    |> Enum.sum()
  end

  defp solve_machine(%{ax: ax, ay: ay, bx: bx, by: by, px: px, py: py}) do
    # Solve the system of linear equations:
    # a * ax + b * bx = px
    # a * ay + b * by = py
    #
    # Using Cramer's rule:
    # det = ax * by - ay * bx
    # a = (px * by - py * bx) / det
    # b = (ax * py - ay * px) / det
    det = ax * by - ay * bx

    if det == 0 do
      0
    else
      a_num = px * by - py * bx
      b_num = ax * py - ay * px

      # Check if solutions are integers
      if rem(a_num, det) == 0 and rem(b_num, det) == 0 do
        a = div(a_num, det)
        b = div(b_num, det)

        # Only check for non-negative values (no 100-press limit in Part 2)
        if a >= 0 and b >= 0 do
          3 * a + b
        else
          0
        end
      else
        0
      end
    end
  end
end
