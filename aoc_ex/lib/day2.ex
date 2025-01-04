defmodule Day2 do
  # Safe - 1, unsafe - 0
  def part1 do
    File.stream!("day2.txt")
    |> Enum.map(&String.split/1)
    |> Enum.map(fn line ->
      Enum.map(line, fn item -> String.to_integer(item) end)
      |> handle_list()
    end)
    |> Enum.filter(fn num -> num == 1 end)
    |> Enum.sum()
  end

  def handle_list([head | tail]) do
    diff = head - List.first(tail)

    case diff do
      0 -> 0
      x when abs(x) in 1..3 -> handle_list(tail, diff)
      _ -> 0
    end
  end

  def handle_list([head | tail], last_diff) do
    if Enum.count(tail) == 0 do
      1
    else
      diff = head - List.first(tail)
      IO.puts(diff)

      if diff > 0 == last_diff > 0 do
        case diff do
          x when abs(x) in 1..3 ->
            handle_list(tail, diff)

          _ ->
            0
        end
      else
        0
      end
    end
  end

  def part2 do
    File.stream!("day2.txt")
    |> Enum.map(&String.split/1)
    |> Enum.map(fn line ->
      Enum.map(line, fn item -> String.to_integer(item) end)
      |> handle_list_dampened()
    end)
    |> Enum.filter(fn num -> num == 1 end)
    |> Enum.sum()
    |> IO.puts()
  end

  def handle_list_dampened([head | tail], dampener_count \\ 0) do
    diff = head - List.first(tail)

    case diff do
      x when abs(x) in 1..3 -> handle_list_dampened(tail, diff, dampener_count)
      _ -> handle_list_dampened(tail, dampener_count + 1)
    end
  end

  def handle_list_dampened([head | tail], last_diff, dampener_count) do
    if dampener_count > 1 do
      0
    else
      if Enum.count(tail) == 0 do
        1
      else
        diff = head - List.first(tail)

        if diff > 0 == last_diff > 0 do
          case diff do
            x when abs(x) in 1..3 ->
              handle_list_dampened(tail, diff, dampener_count)

            _ ->
              handle_list_dampened(tail, last_diff, dampener_count + 1)
          end
        else
          handle_list_dampened(tail, last_diff, dampener_count + 1)
        end
      end
    end
  end
end
