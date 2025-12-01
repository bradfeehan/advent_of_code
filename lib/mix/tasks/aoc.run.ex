defmodule Mix.Tasks.Aoc.Run do
  use Mix.Task

  @shortdoc "Executes a day's solution with the stored puzzle input"
  @switches [year: :integer]
  @aliases [y: :year]

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("app.start")

    case parse_args(args) do
      {:ok, config} ->
        execute(config)

      {:error, message} ->
        Mix.raise(message)
    end
  end

  defp execute(config) do
    case Aoc.Runner.run(config.day, config.part, project_root: config.project_root) do
      {:ok, result} ->
        Mix.shell().info("Result: #{inspect(result)}")
        Mix.shell().info("Submit at #{Aoc.Runner.submission_url(config.day, year: config.year)}")

      {:error, :missing_input} ->
        Mix.raise(
          "Missing input file at priv/#{AdventOfCode2024.day_directory(config.day)}/input.txt. Generate the day first."
        )

      {:error, :missing_module} ->
        Mix.raise(
          "Module #{AdventOfCode2024.day_module(config.day)} is undefined. Run `mix aoc.gen #{config.day}`."
        )

      {:error, :missing_part} ->
        Mix.raise("The module for day #{config.day} doesn't define part/2.")

      {:error, reason} ->
        Mix.raise("Unable to run day #{config.day}: #{inspect(reason)}")
    end
  end

  defp parse_args(args) do
    {opts, positional, invalid} = OptionParser.parse(args, switches: @switches, aliases: @aliases)

    cond do
      invalid != [] ->
        {:error, "Unknown options: #{inspect(invalid)}"}

      length(positional) != 2 ->
        {:error, "Usage: mix aoc.run DAY PART [--year 2024]"}

      true ->
        [day_str, part_str] = positional

        with {:ok, day} <- parse_day(day_str),
             {:ok, part} <- parse_part(part_str) do
          {:ok,
           %{
             day: day,
             part: part,
             year: opts[:year] || AdventOfCode2024.year(),
             project_root: File.cwd!()
           }}
        end
    end
  end

  defp parse_day(value) do
    case Integer.parse(value) do
      {day, ""} when day in 1..25 -> {:ok, day}
      _ -> {:error, "Day must be between 1 and 25"}
    end
  end

  defp parse_part(value) do
    case Integer.parse(value) do
      {part, ""} when part in 1..2 -> {:ok, part}
      _ -> {:error, "Part must be 1 or 2"}
    end
  end
end
