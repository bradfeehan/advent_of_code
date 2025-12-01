defmodule Day02.Part2 do
  @moduledoc """
  Part 2 — Day 2: Red-Nosed Reports

  Uses the Problem Dampener which tolerates a single bad level.
  If removing any one level makes the report safe, it counts as safe.
  """

  alias Day02.Report

  @spec solve(String.t()) :: integer()
  def solve(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&Report.parse/1)
    |> Enum.count(&Report.safe_with_dampener?/1)
  end
end
