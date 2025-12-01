defmodule Year2024.Day05.Part1 do
  @moduledoc """
  Part 1 — Day 5: Print Queue

  Determines which updates are already in the correct order according to
  page ordering rules, and sums the middle page numbers of those updates.
  """

  @doc """
  Solves Part 1 of Day 5.

  Takes the puzzle input containing ordering rules and updates,
  finds correctly ordered updates, and returns the sum of their
  middle page numbers.
  """
  @spec solve(String.t()) :: integer()
  def solve(input) do
    {rules, updates} = parse_input(input)

    updates
    |> Enum.filter(&valid_order?(&1, rules))
    |> Enum.map(&middle_page/1)
    |> Enum.sum()
  end

  @doc """
  Parses the input into rules and updates.

  Returns a tuple of {rules_set, updates_list} where:
  - rules_set is a MapSet of {before, after} tuples
  - updates_list is a list of lists of page numbers
  """
  @spec parse_input(String.t()) :: {MapSet.t(), [[integer()]]}
  def parse_input(input) do
    [rules_section, updates_section] =
      input
      |> String.trim()
      |> String.split("\n\n", parts: 2)

    rules = parse_rules(rules_section)
    updates = parse_updates(updates_section)

    {rules, updates}
  end

  @spec parse_rules(String.t()) :: MapSet.t()
  defp parse_rules(section) do
    section
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [before, after_page] = String.split(line, "|")
      {String.to_integer(before), String.to_integer(after_page)}
    end)
    |> MapSet.new()
  end

  @spec parse_updates(String.t()) :: [[integer()]]
  defp parse_updates(section) do
    section
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end)
  end

  @doc """
  Checks if an update is in valid order according to the rules.

  An update is valid if for every pair of pages, if there's a rule
  saying the second should come before the first, the update violates it.
  """
  @spec valid_order?([integer()], MapSet.t()) :: boolean()
  def valid_order?(update, rules) do
    update
    |> pairs_with_indices()
    |> Enum.all?(fn {page_before, page_after} ->
      # There should NOT be a rule saying page_after must come before page_before
      not MapSet.member?(rules, {page_after, page_before})
    end)
  end

  @spec pairs_with_indices([integer()]) :: [{integer(), integer()}]
  defp pairs_with_indices(update) do
    for {page_before, i} <- Enum.with_index(update),
        {page_after, j} <- Enum.with_index(update),
        i < j,
        do: {page_before, page_after}
  end

  @doc """
  Returns the middle page number of an update.
  """
  @spec middle_page([integer()]) :: integer()
  def middle_page(update) do
    middle_index = div(length(update), 2)
    Enum.at(update, middle_index)
  end
end
