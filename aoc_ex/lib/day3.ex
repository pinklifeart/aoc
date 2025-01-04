defmodule Day3 do
  def part1 do
    File.stream!("day3.txt")
    |> Enum.map(fn line ->
      Regex.scan(~r/mul\(\d+,\d+\)/, line)
    end)
    |> List.flatten()
    |> Enum.map(fn match ->
      Regex.scan(~r/\d+,\d+/, match)
    end)
    |> List.flatten()
    |> Enum.map(fn pulled ->
      String.split(pulled, ",")
    end)
    |> Enum.map(fn [num1, num2] -> String.to_integer(num1) * String.to_integer(num2) end)
    |> Enum.sum()
    |> IO.puts()
  end

  def part2 do
    File.stream!("day3.txt")
    |> Enum.map(fn line ->
      Regex.scan(~r/mul\(\d+,\d+\)|do(n't)?\(\)/, line)
    end)
    |> List.flatten()
    |> handle_instructions()
    |> Enum.sum()
    |> IO.puts()
  end

  def handle_instructions([inst | tail], enabled \\ true, acc \\ []) do
    case inst do
      "do()" ->
        handle_instructions(tail, true, acc)

      "don't()" ->
        handle_instructions(tail, false, acc)

      i ->
        if enabled do
          mul =
            Regex.scan(~r/\d+/, i)
            |> List.flatten()
            |> then(fn [x, y] -> String.to_integer(x) * String.to_integer(y) end)

          acc = [mul | acc]

          if Enum.count(tail) > 0 do
            handle_instructions(tail, enabled, acc)
          else
            acc
          end
        else
          if Enum.count(tail) > 0 do
            handle_instructions(tail, enabled, acc)
          else
            acc
          end
        end
    end
  end
end
