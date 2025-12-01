defmodule Aoc.SessionTest do
  use ExUnit.Case, async: true
  use Support.TmpDirCase

  test "load/1 returns :missing_session when absent", ctx do
    assert {:error, :missing_session} = Aoc.Session.load(project_root: ctx.tmp_dir)
  end

  test "save/2 persists and trims values", ctx do
    assert :ok = Aoc.Session.save(" abc123\n", project_root: ctx.tmp_dir)
    assert {:ok, "abc123"} = Aoc.Session.load(project_root: ctx.tmp_dir)
  end
end
