defmodule Year2024.Day02.Part1 do
  @moduledoc """
  Part 1 — Day 2: Red-Nosed Reports

  A report is safe if:
  - All levels are either increasing or decreasing
  - Adjacent levels differ by at least 1 and at most 3
  """

  alias Year2024.Day02.Report

  @spec solve(String.t()) :: integer()
  def solve(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&Report.parse/1)
    |> Enum.count(&Report.safe?/1)
  end
end
