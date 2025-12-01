defmodule Year2024.Day12Test do
  use ExUnit.Case, async: true

  @sample_path Path.expand("../../priv/year2024/day12/sample.txt", __DIR__)
  @input_path Path.expand("../../priv/year2024/day12/input.txt", __DIR__)

  describe "part 1" do
    test "works with the sample input" do
      sample = File.read!(@sample_path)
      assert Year2024.Day12.part(1, sample) == 1930
    end

    test "works with the real input" do
      input = File.read!(@input_path)
      assert Year2024.Day12.part(1, input) == 1381056
    end
  end

  describe "part 2" do
    test "works with the sample input" do
      sample = File.read!(@sample_path)
      assert Year2024.Day12.part(2, sample) == 1206
    end

    test "works with the real input" do
      input = File.read!(@input_path)
      assert Year2024.Day12.part(2, input) == 834828
    end
  end

end
