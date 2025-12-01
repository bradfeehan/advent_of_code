defmodule Day03Test do
  use ExUnit.Case, async: true

  @sample_path Path.expand("../priv/day03/sample.txt", __DIR__)
  @input_path Path.expand("../priv/day03/input.txt", __DIR__)

  describe "part 1" do
    test "works with the sample input" do
      sample = File.read!(@sample_path)
      assert Day03.part(1, sample) == 161
    end

    @tag :skip
    test "works with the real input" do
      input = File.read!(@input_path)
      assert Day03.part(1, input) == :not_implemented
    end
  end

  describe "part 2" do
    test "works with the sample input" do
      # Part 2 has a different sample than part 1 (includes do/don't instructions)
      sample = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
      assert Day03.part(2, sample) == 48
    end

    @tag :skip
    test "works with the real input" do
      input = File.read!(@input_path)
      assert Day03.part(2, input) == :not_implemented
    end
  end
end
