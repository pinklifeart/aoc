use std::fs;

#[derive(Debug)]
struct Card {
    winning_numbers: Vec<usize>,
    numbers: Vec<usize>,
    copies: usize,
}

impl Card {
    fn evaluate(&self) -> usize {
        let mut acc = 0_usize;
        for number in &self.numbers {
            if self.winning_numbers.contains(number) {
                acc += 1;
            }
        }

        acc
    }
}

fn main() {
    let input = fs::read_to_string("input.txt").unwrap();

    let mut cards = input
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
            copies: 1,
        })
        .collect::<Vec<Card>>();

    (0..cards.len()).for_each(|idx| {
        let acc = cards[idx].evaluate();
        let multiplier = cards[idx].copies;
        if acc > 0 {
            (idx + 1..idx + acc + 1).for_each(|idx| {
                cards[idx].copies += multiplier;
            });
        }
    });

    let res = cards.iter().fold(0, |acc, card| acc + card.copies);

    println!("{:?}", res);
}
