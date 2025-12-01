defmodule Day02Test do
  use ExUnit.Case, async: true

  @sample_path Path.expand("../priv/day02/sample.txt", __DIR__)
  @input_path Path.expand("../priv/day02/input.txt", __DIR__)

  describe "part 1" do
    test "works with the sample input" do
      sample = File.read!(@sample_path)
      assert Day02.part(1, sample) == 2
    end

    test "works with the real input" do
      input = File.read!(@input_path)
      assert Day02.part(1, input) == 314
    end
  end

  describe "part 2" do
    test "works with the sample input" do
      sample = File.read!(@sample_path)
      assert Day02.part(2, sample) == 4
    end

    test "works with the real input" do
      input = File.read!(@input_path)
      assert Day02.part(2, input) == 373
    end
  end
end
