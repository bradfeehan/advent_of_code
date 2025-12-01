defmodule Mix.Tasks.Aoc.Gen do
  use Mix.Task

  @shortdoc "Generates scaffolding for a specific Advent of Code day"
  @switches [year: :integer, force: :boolean, session: :string]
  @aliases [y: :year, f: :force]

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("app.start")

    with {:ok, config} <- parse_args(args),
         {:ok, day} <- fetch_day(config),
         {:ok, summary} <-
           Aoc.Generator.generate(day, project_root: config.project_root, force: config.force) do
      print_summary(summary, config.project_root)
    else
      {:error, :missing_session} ->
        Mix.raise("""
        No session cookie found. Run `mix aoc.login` first or pass --session <value>.
        """)

      {:error, :invalid_day} ->
        Mix.raise("Day must be between 1 and 25")

      {:error, {:http_error, status}} ->
        Mix.raise("Advent of Code responded with HTTP #{status}. Is the day unlocked?")

      {:error, reason} ->
        Mix.raise("Unable to generate day: #{inspect(reason)}")

      {:invalid_args, message} ->
        Mix.raise(message)
    end
  end

  defp fetch_day(config) do
    opts =
      [year: config.year]
      |> add_if_present(:session, config.session)

    Aoc.Client.fetch_day(config.day, opts)
  end

  defp parse_args(args) do
    {opts, positional, invalid} = OptionParser.parse(args, switches: @switches, aliases: @aliases)

    cond do
      invalid != [] ->
        {:invalid_args, "Unknown options: #{inspect(invalid)}"}

      length(positional) != 1 ->
        {:invalid_args, "Usage: mix aoc.gen DAY [--year 2024] [--force]"}

      true ->
        [day_string] = positional

        with {:ok, day} <- parse_day(day_string) do
          {:ok,
           %{
             day: day,
             year: opts[:year] || AdventOfCode.year(),
             session: opts[:session],
             force: opts[:force] || false,
             project_root: File.cwd!()
           }}
        end
    end
  end

  defp parse_day(day_string) do
    day_string
    |> Integer.parse()
    |> case do
      {day, ""} when day in 1..25 -> {:ok, day}
      _ -> {:error, :invalid_day}
    end
  end

  defp add_if_present(keyword, _key, nil), do: keyword
  defp add_if_present(keyword, key, value), do: Keyword.put(keyword, key, value)

  defp print_summary(summary, root) do
    Enum.each(Enum.reverse(summary.written), fn path ->
      Mix.shell().info("create #{relative(path, root)}")
    end)

    Enum.each(Enum.reverse(summary.skipped), fn path ->
      Mix.shell().info("skip   #{relative(path, root)} (exists, use --force to overwrite)")
    end)
  end

  defp relative(path, root) do
    Path.relative_to(path, root)
  rescue
    ArgumentError -> path
  end
end
