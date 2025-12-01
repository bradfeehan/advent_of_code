defmodule Support.TmpDirCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      import Support.TmpDirCase, only: [tmp_path: 2]
    end
  end

  setup context do
    tmp_dir =
      System.tmp_dir!()
      |> Path.join("aoc_#{context[:case]}_#{context.test}")
      |> tap(&File.rm_rf!/1)
      |> tap(&File.mkdir_p!/1)

    on_exit(fn -> File.rm_rf(tmp_dir) end)

    {:ok, tmp_dir: tmp_dir}
  end

  def tmp_path(%{tmp_dir: tmp_dir}, relative) do
    Path.join(tmp_dir, relative)
  end
end
