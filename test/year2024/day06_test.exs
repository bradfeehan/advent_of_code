defmodule Year2024.Day06Test do
  use ExUnit.Case, async: true

  @sample_path Path.expand("../../priv/year2024/day06/sample.txt", __DIR__)
  @input_path Path.expand("../../priv/year2024/day06/input.txt", __DIR__)

  describe "part 1" do
    test "works with the sample input" do
      sample = File.read!(@sample_path)
      assert Year2024.Day06.part(1, sample) == 41
    end

    @tag :skip
    test "works with the real input" do
      input = File.read!(@input_path)
      assert Year2024.Day06.part(1, input) == 5086
    end
  end

  describe "part 2" do
    test "works with the sample input" do
      sample = File.read!(@sample_path)
      assert Year2024.Day06.part(2, sample) == 6
    end

    test "works with the real input" do
      input = File.read!(@input_path)
      assert Year2024.Day06.part(2, input) == 1770
    end
  end
end
