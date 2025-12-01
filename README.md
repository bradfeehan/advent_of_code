# Advent of Code 2024 Toolkit

This project codifies the workflow described in `AGENTS.md` for solving Advent of
Code 2024 puzzles in Elixir. It provides Mix tasks for authenticating,
scaffolding each day, and running the generated solutions.

## Prerequisites

- Elixir 1.19.4 / OTP 28.2 (`mise install` takes care of this)
- An active Advent of Code session cookie (see below)

Install dependencies with:

```bash
mise exec -- mix deps.get
```

## Session management

Run `mix aoc.login` once to store your Advent of Code `session` cookie in
`.aoc_session` (ignored by git):

```bash
mise exec -- mix aoc.login
```

## Generating a day

`mix aoc.gen DAY` downloads the description, puzzle input, and sample data, then
generates:

- `lib/dayXX.ex` delegator plus `lib/dayXX/part{1,2}.ex` stubs
- `priv/dayXX/description.md`, `sample.txt`, `input.txt`
- `test/dayXX_test.exs`

Example:

```bash
mise exec -- mix aoc.gen 1
```

Use `--force` to overwrite files or `--session`/`--year` to override defaults.

## Running a solution

After filling in the stubs, execute a solution with:

```bash
mise exec -- mix aoc.run DAY PART
```

The task loads `priv/dayXX/input.txt`, calls `DayXX.part(part, input)`, prints
the result, and echoes the official submission URL.

## Project structure

- `lib/aoc/*` – shared infrastructure (session storage, HTTP client, generator,
  runner)
- `lib/mix/tasks/aoc.*` – CLI entry points
- `priv/dayXX/*` – downloaded assets per day
- `test/` – regression tests for the infrastructure plus per-day placeholders

