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

end
