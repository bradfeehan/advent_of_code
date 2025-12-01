defmodule Aoc.Client do
  @moduledoc """
  HTTP client responsible for retrieving Advent of Code puzzle data.
  """

  alias Aoc.Client.Day
  alias Aoc.Client.Day.Part

  @base_url "https://adventofcode.com"
  @default_headers [
    {"accept", "text/html,application/xhtml+xml"},
    {"user-agent", "advent_of_code_2024 (github.com/bradfeehan/advent-of-code-2024)"}
  ]

  @spec fetch_day(pos_integer(), keyword()) :: {:ok, Day.t()} | {:error, term()}
  def fetch_day(day, opts \\ []) when is_integer(day) do
    year = Keyword.get(opts, :year, AdventOfCode2024.year())

    with {:ok, _slug} <- safe_day_slug(day),
         {:ok, session} <- fetch_session(opts),
         {:ok, description_html} <- fetch_description_html(year, day, session, opts),
         {:ok, puzzle_input} <- fetch_puzzle_input(year, day, session, opts),
         {:ok, day_struct} <- parse_day(description_html, puzzle_input, day: day, year: year) do
      {:ok, day_struct}
    end
  end

  @doc false
  @spec parse_day(String.t(), String.t(), keyword()) :: {:ok, Day.t()} | {:error, term()}
  def parse_day(html, puzzle_input, opts) when is_binary(html) and is_binary(puzzle_input) do
    day = Keyword.fetch!(opts, :day)
    year = Keyword.fetch!(opts, :year)

    with {:ok, document} <- Floki.parse_document(html) do
      parts = Floki.find(document, "article.day-desc")

      case parts do
        [] ->
          {:error, :missing_description}

        [first | _] ->
          rendered_parts = render_parts(parts)

          {:ok,
           %Day{
             day: day,
             year: year,
             title: extract_title(first),
             parts: rendered_parts,
             sample_inputs: extract_samples(document),
             puzzle_input: normalize_input(puzzle_input),
             part_two_unlocked?: Enum.any?(rendered_parts, &(&1.number == 2))
           }}
      end
    else
      {:error, _} = error -> error
    end
  end

  defp safe_day_slug(day) do
    {:ok, AdventOfCode2024.day_slug(day)}
  rescue
    ArgumentError -> {:error, :invalid_day}
  end

  defp fetch_session(opts) do
    case Keyword.get(opts, :session) do
      nil -> Aoc.Session.load(opts)
      session -> {:ok, session}
    end
  end

  defp fetch_description_html(year, day, session, opts) do
    url = "#{@base_url}/#{year}/day/#{day}"
    request(url, session, opts)
  end

  defp fetch_puzzle_input(year, day, session, opts) do
    url = "#{@base_url}/#{year}/day/#{day}/input"
    request(url, session, opts)
  end

  defp request(url, session, opts) do
    headers = session_headers(session, opts)

    opts
    |> Keyword.get(:req_options, [])
    |> Keyword.put(:url, url)
    |> Keyword.put_new(:method, :get)
    |> Keyword.put(:headers, headers)
    |> Req.request()
    |> handle_response()
  end

  defp session_headers(session, opts) do
    override = Keyword.get(opts, :headers, [])
    cookie_header = {"cookie", "session=#{session}"}
    @default_headers ++ [cookie_header] ++ override
  end

  defp handle_response({:ok, %{status: status, body: body}})
       when status in 200..299 do
    {:ok, body}
  end

  defp handle_response({:ok, %{status: status}}) do
    {:error, {:http_error, status}}
  end

  defp handle_response({:error, reason}), do: {:error, reason}

  defp render_parts(parts) do
    parts
    |> Enum.with_index(1)
    |> Enum.map(fn {article, index} ->
      %Part{
        number: index,
        markdown:
          article
          |> Floki.raw_html()
          |> Htmd.convert!(
            code_block_style: :fenced,
            code_block_fence: :backticks,
            bullet_list_marker: :dash,
            ul_bullet_spacing: 1,
            preformatted_code: true
          )
          |> String.trim()
      }
    end)
  end

  defp extract_title(article) do
    article
    |> Floki.find("h2")
    |> Floki.text()
    |> String.trim()
    |> String.trim_leading("--- ")
    |> String.trim_trailing(" ---")
  end

  defp extract_samples(document) do
    document
    |> Floki.find("article.day-desc pre code")
    |> Enum.map(&Floki.text(&1, sep: "\n"))
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end

  defp normalize_input(input) do
    input
    |> String.replace("\r\n", "\n")
    |> String.replace(~r/\n+\z/u, "")
  end
end
