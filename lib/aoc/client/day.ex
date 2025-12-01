defmodule Aoc.Client.Day do
  @moduledoc """
  Structured representation of a day's Advent of Code content.
  """

  alias __MODULE__.Part

  @enforce_keys [:day, :year, :title, :parts, :sample_inputs, :puzzle_input, :part_two_unlocked?]
  defstruct [:day, :year, :title, :parts, :sample_inputs, :puzzle_input, :part_two_unlocked?]

  @type t :: %__MODULE__{
          day: pos_integer(),
          year: pos_integer(),
          title: String.t(),
          parts: [Part.t()],
          sample_inputs: [String.t()],
          puzzle_input: String.t(),
          part_two_unlocked?: boolean()
        }

  defmodule Part do
    @moduledoc "Represents the rendered Markdown for a single puzzle part."

    @enforce_keys [:number, :markdown, :unlocked?]
    defstruct [:number, :markdown, :unlocked?]

    @type t :: %__MODULE__{
            number: pos_integer(),
            markdown: String.t(),
            unlocked?: boolean()
          }
  end
end
