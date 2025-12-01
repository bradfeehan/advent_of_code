defmodule Day10Test do
  use ExUnit.Case, async: true

  @sample_path Path.expand("../priv/day10/sample.txt", __DIR__)
  @input_path Path.expand("../priv/day10/input.txt", __DIR__)

  describe "part 1" do
    @tag :skip
    test "works with the sample input" do
      sample = File.read!(@sample_path)
      assert Day10.part(1, sample) == :not_implemented
    end

    @tag :skip
    test "works with the real input" do
      input = File.read!(@input_path)
      assert Day10.part(1, input) == :not_implemented
    end
  end

end
