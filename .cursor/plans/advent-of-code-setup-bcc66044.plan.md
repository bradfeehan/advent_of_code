<!-- bcc66044-bec6-40b9-83d9-574f172568a2 0cfb9146-fd63-40a3-aa16-b3f39542eacb -->
# Advent of Code 2024 Setup Plan

## 1. Project Initialization

- Initialize a new Elixir project in the current directory with application name `advent_of_code_2024`.
- Configure `mix.exs` to include `floki` ~> 0.38 for HTML parsing, `req` ~> 0.5, and `htmd` ~> 0.2.
- Ensure OTP 28.2 and Elixir 1.19.4 compatibility.

## 2. Session Management (`mix aoc.login`)

- Create `lib/mix/tasks/aoc.login.ex`.
- Implement a task to prompt the user for their Advent of Code session cookie.
- Save the cookie to `.aoc_session` in the project root (ensure this file is added to `.gitignore`).

## 3. HTTP Client & Parsing (`Aoc.Client`)

- Create `lib/aoc/client.ex`.
- Use `Req` for HTTP requests.
- Implement logic to parse the day's description (HTML -> Markdown) using `htmd` for AoC's specific HTML structure (handling `pre`, `code`, `em`, `ul`).
- Extract sample/input data using `Floki`.
- Handle "locked" Part 2 state.

## 4. Generator Task (`mix aoc.gen`)

- Create `lib/mix/tasks/aoc.gen.ex`.
- Accept a day number (1-25).
- Create directory structure:
    - `lib/dayXX.ex` (Main delegator module)
    - `lib/dayXX/part1.ex` (Part 1 logic stub)
    - `lib/dayXX/part2.ex` (Part 2 logic stub - conditional on availability)
    - `priv/dayXX/description.md`
    - `priv/dayXX/sample.txt`
    - `priv/dayXX/input.txt`
    - `test/dayXX_test.exs`
- Logic to check if Part 2 is unlocked. If so, generate Part 2 stub; otherwise print a message.
- Generate test file with a placeholder comment for sample assertions.

## 5. Runner Task (`mix aoc.run`)

- Create `lib/mix/tasks/aoc.run.ex`.
- Accept day and part numbers (e.g., `mix aoc.run 1 1`).
- Execute the corresponding function (`DayXX.part/2`).
- Output the result and the submission URL (e.g. `https://adventofcode.com/2024/day/1/answer`).

## 6. Code Structure

- **Main Module (`lib/dayXX.ex`)**: Delegates `part(1, input)` to `DayXX.Part1` and `part(2, input)` to `DayXX.Part2`.
- **Part Modules**: contain the actual logic.
- **Assets**: Stored in `priv/`.

## 7. Verification

- Verify `mix aoc.login` creates the session file.
- Verify `mix aoc.gen 1` creates the files and fetches content (simulated or dry-run if strictly needing auth).
- Verify `mix aoc.run 1 1` runs the stub code.