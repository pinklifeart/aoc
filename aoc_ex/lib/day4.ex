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
    Enum.map(input, fn line -> String.trim(line) |> String.to_charlist() end)
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

  def part2(filename \\ "day4.txt") do
    content = File.stream!(filename)

    part1 =
      content
      |> Day4.numerify()

    part2 =
      content
      |> Enum.reverse()
      |> Day4.numerify()
      |> Enum.reverse()

    Enum.zip_with(part1, part2, fn part1_inner, part2_inner ->
      Enum.zip_with(part1_inner, part2_inner, fn x, y -> x + y end)
    end)
    |> List.flatten()
    |> Enum.filter(fn x -> x == 6 end)
    |> Enum.count()
  end

  def numerify(list) do
    list
    |> Day4.preprocess_data()
    |> Day4.rotate_45deg()
    |> Enum.map(fn line -> Kernel.to_string(line) end)
    |> Enum.map(fn line -> Regex.replace(~r/MAS/, line, "132") end)
    |> Enum.map(fn line -> Regex.replace(~r/(2|S)A(1|M)/, line, "231") end)
    |> Day4.preprocess_data()
    |> Day4.revert_45deg_rotation()
    |> Enum.map(&Kernel.to_string(&1))
    |> Enum.map(&Regex.replace(~r/(X|M|A|S)/, &1, "0"))
    |> Enum.map(&String.codepoints/1)
    |> Enum.map(&Enum.map(&1, fn int -> String.to_integer(int) end))
  end

  def revert_45deg_rotation(list) do
    len =
      Enum.map(list, fn inner -> Enum.count(inner) end)
      |> Enum.max()

    acc = List.duplicate(nil, len)

    revert_45deg_rotation(list, len, acc)
  end

  def revert_45deg_rotation(list, len, acc, counter \\ 0) do
    case list do
      [] ->
        acc

      _ ->
        {head, tail} = Enum.split(list, len)

        {first_elements, head_popped} =
          Enum.map(head, fn line ->
            List.pop_at(line, 0)
          end)
          |> Enum.unzip()

        acc = List.replace_at(acc, counter, first_elements)

        head_cleaned = Enum.reject(head_popped, &(&1 == []))
        revert_45deg_rotation(head_cleaned ++ tail, len, acc, counter + 1)
    end
  end
end
