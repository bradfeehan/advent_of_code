defmodule Year2024.Day13.Part1 do
  @moduledoc """
  Part 1 — Day 13: Claw Contraption

  Each claw machine has two buttons (A and B) that move the claw by specific amounts.
  Button A costs 3 tokens, Button B costs 1 token.
  Find the minimum tokens needed to reach each prize location.
  """

  @spec solve(String.t()) :: integer()
  def solve(input) do
    input
    |> parse_machines()
    |> Enum.map(&solve_machine/1)
    |> Enum.sum()
  end

  defp parse_machines(input) do
    input
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&parse_machine/1)
  end

  defp parse_machine(block) do
    lines = String.split(block, "\n")

    [ax, ay] = parse_button(Enum.at(lines, 0))
    [bx, by] = parse_button(Enum.at(lines, 1))
    [px, py] = parse_prize(Enum.at(lines, 2))

    %{ax: ax, ay: ay, bx: bx, by: by, px: px, py: py}
  end

  defp parse_button(line) do
    Regex.scan(~r/[XY]\+(\d+)/, line)
    |> Enum.map(fn [_, n] -> String.to_integer(n) end)
  end

  defp parse_prize(line) do
    Regex.scan(~r/[XY]=(\d+)/, line)
    |> Enum.map(fn [_, n] -> String.to_integer(n) end)
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

        # Check constraints: both must be non-negative and <= 100
        if a >= 0 and a <= 100 and b >= 0 and b <= 100 do
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
