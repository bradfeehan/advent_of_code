defmodule Day01Test do
  use ExUnit.Case, async: true

  @sample_path Path.expand("../priv/day01/sample.txt", __DIR__)
  @input_path Path.expand("../priv/day01/input.txt", __DIR__)

  describe "part 1" do
    test "works with the sample input" do
      sample = File.read!(@sample_path)
      assert Day01.part(1, sample) == 11
    end

    test "works with the real input" do
      input = File.read!(@input_path)
      assert Day01.part(1, input) == 1_646_452
    end
  end

  describe "part 2" do
    # test "works with the sample input" do
    #   sample = File.read!(@sample_path)
    #   assert Day01.part(2, sample) == 31
    # end
  end
end
