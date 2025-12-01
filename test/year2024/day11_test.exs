defmodule Year2024.Day11Test do
  use ExUnit.Case, async: true

  alias Year2024.Day11.Stone

  @sample_path Path.expand("../../priv/year2024/day11/sample.txt", __DIR__)
  @input_path Path.expand("../../priv/year2024/day11/input.txt", __DIR__)

  describe "Stone.transform/1" do
    test "0 becomes 1" do
      assert Stone.transform(0) == [1]
    end

    test "1 becomes 2024 (multiply by 2024)" do
      assert Stone.transform(1) == [2024]
    end

    test "10 splits into 1 and 0" do
      assert Stone.transform(10) == [1, 0]
    end

    test "99 splits into 9 and 9" do
      assert Stone.transform(99) == [9, 9]
    end

    test "999 becomes 2021976 (multiply by 2024)" do
      assert Stone.transform(999) == [2021976]
    end

    test "1000 splits into 10 and 0" do
      assert Stone.transform(1000) == [10, 0]
    end
  end

  describe "example from description (0 1 10 99 999)" do
    test "after 1 blink becomes 1 2024 1 0 9 9 2021976" do
      stones = Stone.parse("0 1 10 99 999")
      counts = Stone.to_counts(stones)
      result = Stone.blink_counts(counts, 1)

      assert Stone.count_stones(result) == 7
    end
  end

  describe "longer example from description (125 17)" do
    setup do
      {:ok, counts: Stone.to_counts([125, 17])}
    end

    test "after 1 blink has 3 stones", %{counts: counts} do
      result = Stone.blink_counts(counts, 1)
      assert Stone.count_stones(result) == 3
    end

    test "after 2 blinks has 4 stones", %{counts: counts} do
      result = Stone.blink_counts(counts, 2)
      assert Stone.count_stones(result) == 4
    end

    test "after 3 blinks has 5 stones", %{counts: counts} do
      result = Stone.blink_counts(counts, 3)
      assert Stone.count_stones(result) == 5
    end

    test "after 4 blinks has 9 stones", %{counts: counts} do
      result = Stone.blink_counts(counts, 4)
      assert Stone.count_stones(result) == 9
    end

    test "after 5 blinks has 13 stones", %{counts: counts} do
      result = Stone.blink_counts(counts, 5)
      assert Stone.count_stones(result) == 13
    end

    test "after 6 blinks has 22 stones", %{counts: counts} do
      result = Stone.blink_counts(counts, 6)
      assert Stone.count_stones(result) == 22
    end

    test "after 25 blinks has 55312 stones", %{counts: counts} do
      result = Stone.blink_counts(counts, 25)
      assert Stone.count_stones(result) == 55312
    end
  end

  describe "part 1" do
    test "works with the sample input" do
      sample = File.read!(@sample_path)
      assert Year2024.Day11.part(1, sample) == 55312
    end

    test "works with the real input" do
      input = File.read!(@input_path)
      assert Year2024.Day11.part(1, input) == 193_269
    end
  end

  describe "part 2" do
    test "works with the real input" do
      input = File.read!(@input_path)
      assert Year2024.Day11.part(2, input) == 228_449_040_027_793
    end
  end
end
