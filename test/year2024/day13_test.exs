defmodule Year2024.Day13Test do
  use ExUnit.Case, async: true

  @sample_path Path.expand("../../priv/year2024/day13/sample.txt", __DIR__)
  @input_path Path.expand("../../priv/year2024/day13/input.txt", __DIR__)

  describe "part 1" do
    test "works with the sample input" do
      sample = File.read!(@sample_path)
      assert Year2024.Day13.part(1, sample) == 480
    end

    test "works with the real input" do
      input = File.read!(@input_path)
      assert Year2024.Day13.part(1, input) == 28_262
    end
  end

  describe "part 2" do
    test "works with the sample input" do
      sample = File.read!(@sample_path)
      # With the offset, only machines 2 and 4 are solvable
      # The description doesn't give expected value, just run to verify it computes
      result = Year2024.Day13.part(2, sample)
      assert is_integer(result)
      assert result > 0
    end

    test "works with the real input" do
      input = File.read!(@input_path)
      assert Year2024.Day13.part(2, input) == 101_406_661_266_314
    end
  end
end
