defmodule Day4Test do
  use ExUnit.Case
  doctest Day4

  test "sample data part 1" do
    assert Day4.part1("test/sample_d4.txt") == 18
  end

  test "pad with nil to double length and shift right" do
    assert Day4.pad_and_shift_right(~c"abc", 1) == [nil, ?a, ?b, ?c, nil, nil]
  end

  test "rotate 90 degrees" do
    assert Day4.rotate_90deg([["a", "b"], ["c", "d"]]) == [["a", "c"], ["b", "d"]]
  end

  test "rotate 90 charlist" do
    assert Day4.rotate_90deg([~c"as", ~c"df"]) == [~c"ad", ~c"sf"]
  end

  test "rotate 45 degrees" do
    assert Day4.rotate_45deg([["a", "b"], ["c", "d"]]) == [["a"], ["b", "c"], ["d"]]
  end
end
