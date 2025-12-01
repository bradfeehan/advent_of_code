defmodule Day04Test do
  use ExUnit.Case, async: true

  @sample_path Path.expand("../priv/day04/sample.txt", __DIR__)
  @input_path Path.expand("../priv/day04/input.txt", __DIR__)

  describe "part 1" do
    test "works with the sample input" do
      sample = File.read!(@sample_path)
      assert Day04.part(1, sample) == 18
    end

    @tag :skip
    test "works with the real input" do
      input = File.read!(@input_path)
      assert Day04.part(1, input) == :not_implemented
    end
  end

  describe "part 2" do
    test "works with the sample input" do
      sample = File.read!(@sample_path)
      assert Day04.part(2, sample) == 9
    end

    @tag :skip
    test "works with the real input" do
      input = File.read!(@input_path)
      assert Day04.part(2, input) == :not_implemented
    end
  end

end
