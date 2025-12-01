defmodule Aoc.ClientTest do
  use ExUnit.Case, async: true

  alias Aoc.Client

  describe "parse_day/3" do
    test "extracts both parts and metadata when unlocked" do
      html = File.read!(fixture("2024-day1-with-part2.html"))

      assert {:ok, day} = Client.parse_day(html, "a\nb\n", day: 1, year: 2024)
      assert day.title == "Day 1: Historian Hysteria"
      assert day.part_two_unlocked?
      assert Enum.map(day.parts, & &1.number) == [1, 2]
      assert hd(day.sample_inputs) =~ "3   4"
      assert day.puzzle_input == "a\nb"
    end

    test "detects locked part two" do
      html = File.read!(fixture("2024-day1-part1.html"))

      assert {:ok, day} = Client.parse_day(html, "input\n", day: 1, year: 2024)
      refute day.part_two_unlocked?
      assert Enum.map(day.parts, & &1.number) == [1]
    end
  end

  defp fixture(name) do
    Path.expand("../support/fixtures/#{name}", __DIR__)
  end
end
