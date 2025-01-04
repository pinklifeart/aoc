defmodule Day1 do
  def part1 do
    File.stream!("day1.txt")
    |> Enum.map(&String.split/1)
    |> Enum.zip_with(fn list ->
      Enum.map(list, fn num -> String.to_integer(num) end) |> Enum.sort()
    end)
    |> Enum.zip()
    |> Enum.map(fn {n1, n2} -> abs(n1 - n2) end)
    |> Enum.sum()
  end

  def part2 do
    File.stream!("day1.txt")
    |> Enum.map(&String.split/1)
    |> Enum.zip_with(fn list ->
      Enum.map(list, fn num -> String.to_integer(num) end) |> Enum.sort()
    end)
    |> then(fn [main, sub] ->
      Enum.map(main, fn e -> e * (Enum.filter(sub, fn x -> x === e end) |> Enum.count()) end)
    end)
    |> Enum.filter(fn e -> e !== 0 end)
    |> Enum.sum()
  end
end
