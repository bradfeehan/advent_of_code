defmodule Day09Test do
  use ExUnit.Case, async: true

  @sample_path Path.expand("../priv/day09/sample.txt", __DIR__)
  @input_path Path.expand("../priv/day09/input.txt", __DIR__)

  describe "part 1" do
    test "works with the sample input" do
      sample = File.read!(@sample_path) |> String.split("\n") |> List.first() |> String.trim()
      assert Day09.part(1, sample) == 1928
    end

    @tag :skip
    test "works with the real input" do
      input = File.read!(@input_path) |> String.trim()
      assert Day09.part(1, input) == :not_implemented
    end
  end

  describe "part 2" do
    test "works with the sample input" do
      sample = File.read!(@sample_path) |> String.split("\n") |> List.first() |> String.trim()
      assert Day09.part(2, sample) == 2858
    end

    @tag :skip
    test "works with the real input" do
      input = File.read!(@input_path) |> String.trim()
      assert Day09.part(2, input) == :not_implemented
    end
  end

end
