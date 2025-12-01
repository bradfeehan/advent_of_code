defmodule Year2024.Day07Test do
  use ExUnit.Case, async: true

  @sample_path Path.expand("../../priv/year2024/day07/sample.txt", __DIR__)
  @input_path Path.expand("../../priv/year2024/day07/input.txt", __DIR__)

  describe "part 1" do
    test "works with the sample input" do
      sample = File.read!(@sample_path)
      assert Year2024.Day07.part(1, sample) == 3749
    end

    test "works with the real input" do
      input = File.read!(@input_path)
      assert Year2024.Day07.part(1, input) == 1_620_690_235_709
    end
  end

  describe "part 2" do
    test "works with the sample input" do
      sample = File.read!(@sample_path)
      assert Year2024.Day07.part(2, sample) == 11387
    end

    test "works with the real input" do
      input = File.read!(@input_path)
      assert Year2024.Day07.part(2, input) == 145_397_611_075_341
    end
  end
end
