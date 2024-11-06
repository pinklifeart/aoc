use std::fs;

struct Card {
    winning_numbers: Vec<usize>,
    numbers: Vec<usize>,
}

impl Card {
    fn get_value(&self) -> f64 {
        let mut acc = 0.5;
        for number in &self.numbers {
            if self.winning_numbers.contains(number) {
                acc *= 2_f64;
            }
        }

        acc.floor()
    }
}

fn main() {
    let input = fs::read_to_string("input.txt").unwrap();

    let res = input
        .lines()
        .map(|line| {
            line.split_terminator(':')
                .last()
                .unwrap()
                .split_terminator('|')
                .map(|half| {
                    half.split_whitespace()
                        .map(|num| num.parse::<usize>().unwrap())
                        .collect::<Vec<usize>>()
                })
                .collect::<Vec<Vec<usize>>>()
        })
        .map(|x| Card {
            winning_numbers: x[0].clone(),
            numbers: x[1].clone(),
        })
        .map(|card| card.get_value())
        .fold(0_f64, |acc, num| acc + num);

    println!("{:?}", res);
}
