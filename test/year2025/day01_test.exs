defmodule Year2025.Day01Test do
  use ExUnit.Case, async: true

  @sample_path Path.expand("../../priv/year2025/day01/sample.txt", __DIR__)
  @input_path Path.expand("../../priv/year2025/day01/input.txt", __DIR__)

  describe "part 1" do
    test "works with the sample input" do
      sample = File.read!(@sample_path)
      assert Year2025.Day01.part(1, sample) == 3
    end

    test "works with the real input" do
      input = File.read!(@input_path)
      assert Year2025.Day01.part(1, input) == 1076
    end
  end

  describe "part 2" do
    test "works with the sample input" do
      sample = File.read!(@sample_path)
      assert Year2025.Day01.part(2, sample) == 6
    end

    test "works with the real input" do
      input = File.read!(@input_path)
      assert Year2025.Day01.part(2, input) == 6379
    end
  end
end
