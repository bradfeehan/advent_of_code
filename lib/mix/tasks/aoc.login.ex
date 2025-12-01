defmodule Mix.Tasks.Aoc.Login do
  use Mix.Task

  @shortdoc "Stores your Advent of Code session cookie locally"

  @impl Mix.Task
  def run(_args) do
    Mix.shell().info("""
    Copy the value of the `session` cookie from adventofcode.com and paste it below.
    It will be stored in #{Aoc.Session.file_path()} and used for authenticated requests.
    """)

    cookie =
      Mix.Shell.IO.prompt("session cookie> ")
      |> String.trim()

    case Aoc.Session.save(cookie) do
      :ok ->
        Mix.shell().info("Session saved to #{Aoc.Session.file_path()}")

      {:error, :invalid_session} ->
        Mix.raise("Session cookie cannot be blank")

      {:error, reason} ->
        Mix.raise("Unable to persist session cookie: #{inspect(reason)}")
    end
  end
end
