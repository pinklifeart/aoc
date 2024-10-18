use std::fs;

#[derive(Debug)]
struct Game {
    min_red: u32,
    min_green: u32,
    min_blue: u32,
}

fn main() {
    let input = fs::read_to_string("input.txt").unwrap();

    let sum = input
        .lines()
        .map(|line| {
            let (gid, rounds) = line.split_at(line.find(':').unwrap());
            let _id = gid.replace("Game ", "").parse::<u32>().unwrap();
            let mut min_red = 0;
            let mut min_green = 0;
            let mut min_blue = 0;
            rounds
                .strip_prefix(": ")
                .unwrap()
                .split_terminator(";")
                .flat_map(|r| r.split_terminator(","))
                .map(|r| {
                    let r = r.trim();
                    let (amount, kind) = r.split_at(r.find(' ').unwrap());
                    match kind.trim() {
                        "red" => {
                            if amount.parse::<u32>().unwrap() > min_red {
                                min_red = amount.parse::<u32>().unwrap();
                            }
                        }
                        "green" => {
                            if amount.parse::<u32>().unwrap() > min_green {
                                min_green = amount.parse::<u32>().unwrap();
                            }
                        }
                        "blue" => {
                            if amount.parse::<u32>().unwrap() > min_blue {
                                min_blue = amount.parse::<u32>().unwrap();
                            }
                        }
                        _ => {
                            panic!("invalid die!")
                        }
                    }
                })
                .for_each(drop);

            Game {
                min_red,
                min_green,
                min_blue,
            }
        })
        .fold(0, |acc, x| acc + { x.min_blue * x.min_green * x.min_red });

    println!("{}", sum);
}
