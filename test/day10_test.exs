defmodule Day10Test do
  use ExUnit.Case, async: true

  @input_path Path.expand("../priv/day10/input.txt", __DIR__)

  describe "part 1" do
    test "works with the first simple example" do
      # First example: single trailhead with score 1
      sample = """
      0123
      1234
      8765
      9876
      """
      assert Day10.part(1, sample) == 1
    end

    test "works with the sample input" do
      # Using the large example from the description (expected answer: 36)
      sample = """
      89010123
      78121874
      87430965
      96549874
      45678903
      32019012
      01329801
      10456732
      """
      assert Day10.part(1, sample) == 36
    end

    @tag :skip
    test "works with the real input" do
      input = File.read!(@input_path)
      assert Day10.part(1, input) == :not_implemented
    end
  end

  describe "part 2" do
    test "works with the first example" do
      # Example with rating 3
      sample = """
      .....0.
      ..4321.
      ..5..2.
      ..6543.
      ..7..4.
      ..8765.
      ..9....
      """
      assert Day10.part(2, sample) == 3
    end

    test "works with the second example" do
      # Example with rating 13
      sample = """
      ..90..9
      ...1.98
      ...2..7
      6543456
      765.987
      876....
      987....
      """
      assert Day10.part(2, sample) == 13
    end

    test "works with the large sample input" do
      # Using the large example from the description (expected answer: 81)
      sample = """
      89010123
      78121874
      87430965
      96549874
      45678903
      32019012
      01329801
      10456732
      """
      assert Day10.part(2, sample) == 81
    end

    @tag :skip
    test "works with the real input" do
      input = File.read!(@input_path)
      assert Day10.part(2, input) == :not_implemented
    end
  end

end
