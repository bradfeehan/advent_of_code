defmodule Aoc.RunnerTest do
  use ExUnit.Case, async: true
  use Support.TmpDirCase

  describe "run/3" do
    test "invokes the compiled module with the stored input", ctx do
      input_dir = tmp_path(ctx, "priv/year2024/day01")
      File.mkdir_p!(input_dir)
      File.write!(Path.join(input_dir, "input.txt"), "1 2\n")

      assert {:ok, 1} = Aoc.Runner.run(1, 1, year: 2024, project_root: ctx.tmp_dir)
    end

    test "errors when the input is missing", ctx do
      assert {:error, :missing_input} =
               Aoc.Runner.run(1, 1, year: 2024, project_root: ctx.tmp_dir)
    end
  end
end
