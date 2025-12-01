defmodule Day25 do
  @moduledoc false

  def part(1, input), do: String.trim(input)
end

defmodule Aoc.RunnerTest do
  use ExUnit.Case, async: true
  use Support.TmpDirCase

  describe "run/3" do
    test "invokes the compiled module with the stored input", ctx do
      input_dir = tmp_path(ctx, "priv/day25")
      File.mkdir_p!(input_dir)
      File.write!(Path.join(input_dir, "input.txt"), "value\n")

      assert {:ok, "value"} = Aoc.Runner.run(25, 1, project_root: ctx.tmp_dir)
    end

    test "errors when the input is missing", ctx do
      assert {:error, :missing_input} = Aoc.Runner.run(25, 1, project_root: ctx.tmp_dir)
    end

    test "errors when the module does not exist", ctx do
      day_dir = tmp_path(ctx, "priv/day24")
      File.mkdir_p!(day_dir)
      File.write!(Path.join(day_dir, "input.txt"), "42\n")

      assert {:error, :missing_module} = Aoc.Runner.run(24, 1, project_root: ctx.tmp_dir)
    end
  end
end
