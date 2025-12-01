defmodule Aoc.GeneratorTest do
  use ExUnit.Case, async: true
  use Support.TmpDirCase

  alias Aoc.Client.Day
  alias Aoc.Client.Day.Part

  describe "generate/2" do
    test "writes scaffolding for an unlocked day", ctx do
      day = day_fixture(part_two?: true)
      assert {:ok, summary} = Aoc.Generator.generate(day, project_root: ctx.tmp_dir)

      assert Enum.any?(summary.written, &String.ends_with?(&1, "lib/day01.ex"))

      assert ctx
             |> tmp_path("priv/day01/description.md")
             |> File.read!()
             |> String.contains?("Part 2 text")

      assert File.exists?(tmp_path(ctx, "lib/day01/part2.ex"))
      assert File.exists?(tmp_path(ctx, "test/day01_test.exs"))
    end

    test "omits part two files when locked", ctx do
      day = day_fixture(part_two?: false)
      assert {:ok, _} = Aoc.Generator.generate(day, project_root: ctx.tmp_dir)

      refute File.exists?(tmp_path(ctx, "lib/day01/part2.ex"))

      description = File.read!(tmp_path(ctx, "priv/day01/description.md"))
      assert description =~ "Part two is still locked"
    end
  end

  defp day_fixture(opts) do
    part_two? = Keyword.fetch!(opts, :part_two?)

    %Day{
      day: 1,
      year: 2024,
      title: "Historian Hysteria",
      part_two_unlocked?: part_two?,
      sample_inputs: ["3  4"],
      puzzle_input: "1\n2\n3",
      parts:
        [
          %Part{number: 1, markdown: "Part 1 text"}
        ] ++
          if part_two? do
            [%Part{number: 2, markdown: "Part 2 text"}]
          else
            []
          end
    }
  end
end
