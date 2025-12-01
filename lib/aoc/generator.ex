defmodule Aoc.Generator do
  @moduledoc """
  Creates scaffolding for a given Advent of Code day, including module stubs,
  test files, and resource placeholders.
  """

  alias Aoc.Client.Day

  @spec generate(Day.t(), keyword()) :: {:ok, map()}
  def generate(%Day{} = day, opts \\ []) do
    project_root = Keyword.get(opts, :project_root, File.cwd!())
    force? = Keyword.get(opts, :force, false)
    year = day.year
    slug = AdventOfCode.day_slug(day.day)
    module_name = module_name(year, day.day)
    day_dir = AdventOfCode.day_directory(year, day.day)
    lib_day_dir = Path.join([project_root, "lib", day_dir])
    priv_day_dir = Path.join([project_root, "priv", day_dir])

    File.mkdir_p!(lib_day_dir)
    File.mkdir_p!(priv_day_dir)

    operations =
      [
        {Path.join([project_root, "lib", Path.dirname(day_dir), Path.basename(day_dir) <> ".ex"]),
         main_module_template(day, module_name)},
        {Path.join(lib_day_dir, "part1.ex"), part_module_template(day, module_name, 1)}
      ]
      |> maybe_append_part_two(day, module_name, lib_day_dir)
      |> Kernel.++([
        {Path.join(priv_day_dir, "description.md"), description_template(day, slug), force: true},
        {Path.join(priv_day_dir, "sample.txt"), sample_body(day)},
        {Path.join(priv_day_dir, "input.txt"), ensure_trailing_newline(day.puzzle_input)},
        {Path.join([
           project_root,
           "test",
           Path.dirname(day_dir),
           "#{Path.basename(day_dir)}_test.exs"
         ]), test_template(day, module_name, day_dir)}
      ])

    {:ok, Enum.reduce(operations, %{written: [], skipped: []}, &persist(&1, &2, force?))}
  end

  defp persist({path, body}, acc, force?), do: persist({path, body, []}, acc, force?)

  defp persist({path, body, opts}, acc, force?) do
    file_force? = force? or Keyword.get(opts, :force, false)

    case write_file(path, body, file_force?) do
      :written -> %{acc | written: [path | acc.written]}
      :skipped -> %{acc | skipped: [path | acc.skipped]}
    end
  end

  defp write_file(path, body, force?) do
    if File.exists?(path) and not force? do
      :skipped
    else
      path |> Path.dirname() |> File.mkdir_p!()
      File.write!(path, body)
      :written
    end
  end

  defp maybe_append_part_two(list, day, module_name, lib_day_dir) do
    if day.part_two_unlocked? do
      list ++ [{Path.join(lib_day_dir, "part2.ex"), part_module_template(day, module_name, 2)}]
    else
      list
    end
  end

  defp main_module_template(day, module_name) do
    """
    defmodule #{module_name} do
      @moduledoc \"\"\"
      Day #{AdventOfCode.day_slug(day.day)} — #{day.title}
      \"\"\"

      @spec part(1 | 2, String.t()) :: term()
      def part(1, input), do: #{module_name}.Part1.solve(input)
    #{part_two_clause(day, module_name)}

      def part(part, _input) do
        raise ArgumentError, \"unsupported part \#{inspect(part)} for #{module_name}\"
      end
    end
    """
    |> String.trim_trailing()
    |> Kernel.<>("\n")
  end

  defp part_two_clause(%Day{part_two_unlocked?: true}, module_name) do
    """
      def part(2, input), do: #{module_name}.Part2.solve(input)
    """
    |> String.trim_trailing()
  end

  defp part_two_clause(%Day{part_two_unlocked?: false}, _module_name) do
    """
      def part(2, _input) do
        raise \"Part 2 is not yet unlocked\"
      end
    """
    |> String.trim_trailing()
  end

  defp part_module_template(day, module_name, part) do
    part_title =
      Enum.find(day.parts, fn part_struct -> part_struct.number == part end)
      |> case do
        nil -> "Part #{part}"
        _part_struct -> "Part #{part} — #{day.title}"
      end

    """
    defmodule #{module_name}.Part#{part} do
      @moduledoc \"\"\"
      #{part_title}
      \"\"\"

      @spec solve(String.t()) :: term()
      def solve(_input) do
        raise \"Day #{AdventOfCode.day_slug(day.day)} part #{part} has not been implemented yet\"
      end
    end
    """
    |> String.trim_trailing()
    |> Kernel.<>("\n")
  end

  defp description_template(day, slug) do
    part_one = markdown_for(day.parts, 1)

    part_two =
      if day.part_two_unlocked? do
        markdown_for(day.parts, 2)
      else
        "Part two is still locked. Run `mix aoc.gen #{day.day}` again after unlocking it to refresh this file."
      end

    """
    # Day #{slug}: #{day.title}

    ## Part 1

    #{part_one}

    ## Part 2

    #{part_two}
    """
    |> String.trim_trailing()
    |> Kernel.<>("\n")
  end

  defp sample_body(day) do
    day.sample_inputs
    |> Enum.join("\n\n---\n\n")
    |> ensure_trailing_newline()
  end

  defp markdown_for(parts, part_number) do
    parts
    |> Enum.find(fn part -> part.number == part_number end)
    |> case do
      nil -> "*No description available yet*"
      %Day.Part{markdown: markdown} -> markdown
    end
  end

  defp ensure_trailing_newline(""), do: ""

  defp ensure_trailing_newline(body) do
    if String.ends_with?(body, "\n") do
      body
    else
      body <> "\n"
    end
  end

  defp test_template(day, module_name, day_dir) do
    """
    defmodule #{module_name}Test do
      use ExUnit.Case, async: true

      @sample_path Path.expand("../../priv/#{day_dir}/sample.txt", __DIR__)
      @input_path Path.expand("../../priv/#{day_dir}/input.txt", __DIR__)

      describe "part 1" do
        @tag :skip
        test "works with the sample input" do
          sample = File.read!(@sample_path)
          assert #{module_name}.part(1, sample) == :not_implemented
        end

        @tag :skip
        test "works with the real input" do
          input = File.read!(@input_path)
          assert #{module_name}.part(1, input) == :not_implemented
        end
      end
    #{part_two_test_block(day, module_name)}
    end
    """
    |> String.trim_trailing()
    |> Kernel.<>("\n")
  end

  defp part_two_test_block(%Day{part_two_unlocked?: false}, _module_name), do: ""

  defp part_two_test_block(%Day{part_two_unlocked?: true}, module_name) do
    """

      describe "part 2" do
        @tag :skip
        test "works with the sample input" do
          sample = File.read!(@sample_path)
          assert #{module_name}.part(2, sample) == :not_implemented
        end

        @tag :skip
        test "works with the real input" do
          input = File.read!(@input_path)
          assert #{module_name}.part(2, input) == :not_implemented
        end
      end
    """
  end

  defp module_name(year, day) do
    AdventOfCode.day_module(year, day)
    |> Module.split()
    |> Enum.join(".")
  end
end
