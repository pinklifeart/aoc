defmodule Day4 do
  def part1(filename \\ "day4.txt") do
    contents =
      File.stream!(filename)

    horizontal =
      contents
      |> Enum.map(fn line -> Day4.count_xmas(line) end)
      |> Enum.sum()

    vertical =
      contents
      |> Day4.preprocess_data()
      |> Day4.rotate_90deg()
      |> Day4.process_data()

    diagonal_down =
      contents
      |> Day4.preprocess_data()
      |> Day4.rotate_45deg()
      |> Day4.process_data()

    diagonal_up =
      contents
      |> Enum.reverse()
      |> Day4.preprocess_data()
      |> Day4.rotate_45deg()
      |> Day4.process_data()

    horizontal + vertical + diagonal_down + diagonal_up
  end

  def preprocess_data(input) do
    Enum.map(input, fn line -> String.to_charlist(line) end)
  end

  def process_data(input) do
    Enum.map(input, fn line -> Kernel.to_string(line) end)
    |> Enum.map(fn line -> Day4.count_xmas(line) end)
    |> Enum.sum()
  end

  @spec count_xmas(String.t()) :: non_neg_integer()
  def count_xmas(input) do
    xmas =
      Regex.scan(~r/XMAS/, input)
      |> Enum.count()

    samx =
      Regex.scan(~r/SAMX/, input)
      |> Enum.count()

    xmas + samx
  end

  @spec rotate_90deg([charlist()]) :: [charlist()]
  def rotate_90deg(list) do
    Enum.zip(list)
    |> Enum.map(fn list -> Tuple.to_list(list) end)
  end

  @spec rotate_45deg([charlist()]) :: [charlist()]
  def rotate_45deg(list) do
    Day4.recursive_shift(list)
    |> Day4.rotate_90deg()
    |> Enum.map(fn inner -> Enum.reject(inner, fn el -> el == nil end) end)
    |> Enum.reject(fn list -> Enum.empty?(list) end)
  end

  def recursive_shift(list) do
    recursive_shift(list, 0, List.duplicate(nil, Enum.count(list)))
  end

  def recursive_shift([line | tail], counter, acc) do
    acc = List.replace_at(acc, counter, Day4.pad_and_shift_right(line, counter))

    case tail do
      [] -> acc
      _ -> recursive_shift(tail, counter + 1, acc)
    end
  end

  @spec pad_and_shift_right(charlist(), non_neg_integer()) :: charlist()
  def pad_and_shift_right(chars, shift) do
    len = Enum.count(chars)

    [[List.duplicate(nil, shift) | chars] | List.duplicate(nil, len - shift)]
    |> List.flatten()
  end
end
