use std::fs;

const RED: u32 = 12;
const GREEN: u32 = 13;
const BLUE: u32 = 14;

#[derive(Debug)]
struct Game {
    id: u32,
    valid: bool,
}

fn main() {
    let input = fs::read_to_string("input.txt").unwrap();

    let sum = input
        .lines()
        .map(|line| {
            let (gid, rounds) = line.split_at(line.find(':').unwrap());
            let id = gid.replace("Game ", "").parse::<u32>().unwrap();
            let rounds = rounds
                .strip_prefix(": ")
                .unwrap()
                .split_terminator(";")
                .flat_map(|r| r.split_terminator(","))
                .map(|r| {
                    let r = r.trim();
                    let (amount, kind) = r.split_at(r.find(' ').unwrap());
                    match kind.trim() {
                        "blue" => {
                            if amount.parse::<u32>().unwrap() > BLUE {
                                1
                            } else {
                                0
                            }
                        }
                        "red" => {
                            if amount.parse::<u32>().unwrap() > RED {
                                1
                            } else {
                                0
                            }
                        }
                        "green" => {
                            if amount.parse::<u32>().unwrap() > GREEN {
                                1
                            } else {
                                0
                            }
                        }
                        _ => {
                            panic!("invalid die!")
                        }
                    }
                })
                .sum::<u32>();

            let valid = rounds == 0;
            Game { id, valid }
        })
        .fold(0, |acc, x| {
            acc + {
                if x.valid {
                    x.id
                } else {
                    0
                }
            }
        });

    println!("{}", sum);
}
