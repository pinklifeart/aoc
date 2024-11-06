use std::fs;

#[derive(Debug, Clone)]
struct Number {
    value: String,
    start: usize,
    end: usize,
    row: usize,
    // part: bool,
}

impl Number {
    fn find_gears(&self, matrix: &[Vec<char>], gears: &mut Vec<Gear>) -> Self {
        (self.row.saturating_sub(1)..{
            if self.row + 1 == matrix.len() {
                self.row
            } else {
                self.row + 2
            }
        })
            .for_each(|row| {
                (self.start.saturating_sub(1)..{
                    if self.end.saturating_add(2) <= matrix[row].len() {
                        self.end.saturating_add(2)
                    } else {
                        matrix[row].len()
                    }
                })
                    .for_each(|col| {
                        if matrix[row][col] == '*' {
                            if let Some(gear) =
                                gears.iter_mut().find(|g| g.row == row && g.col == col)
                            {
                                gear.neighbouring_numbers.push(self.value.parse().unwrap())
                            } else {
                                gears.push(Gear {
                                    row,
                                    col,
                                    neighbouring_numbers: vec![self.value.parse().unwrap()],
                                })
                            }
                        }
                    })
            });
        self.clone()
    }
}

struct Gear {
    row: usize,
    col: usize,
    neighbouring_numbers: Vec<usize>,
}

fn main() {
    let input = fs::read_to_string("input.txt").unwrap();
    let mut numbers: Vec<Number> = Vec::new();
    let mtx: Vec<Vec<char>> = input.lines().map(|line| line.chars().collect()).collect();
    (0..mtx.len()).for_each(|row| {
        let mut value = String::new();
        let mut start = 0_usize;
        let mut end = 0_usize;
        (0..mtx[row].len()).for_each(|col| match mtx[row][col] {
            c if c.is_ascii_digit() => {
                if start == 0 {
                    start = col;
                }
                value.push(c);
                if col == mtx[row].len() - 1 {
                    end = col;
                    numbers.push(Number {
                        value: value.clone(),
                        start,
                        end,
                        row,
                        // part: false,
                    });
                    value = "".to_owned();
                    start = 0;
                }
            }
            _ => {
                if start != 0 {
                    end = col - 1;
                    numbers.push(Number {
                        value: value.clone(),
                        start,
                        end,
                        row,
                        // part: false,
                    });
                    value = "".to_owned();
                    start = 0;
                }
            }
        })
    });

    let mut gears: Vec<Gear> = Vec::new();
    for num in numbers {
        num.find_gears(&mtx, &mut gears);
    }
    let res = gears
        .iter()
        .filter(|gear| gear.neighbouring_numbers.len() == 2)
        .fold(0, |acc, gear| {
            acc + gear.neighbouring_numbers[0] * gear.neighbouring_numbers[1]
        });
    // let res = numbers
    //     .iter_mut()
    //     .map(|num| num.find_gears(&mtx, &mut gears));
    // .filter(|num| num.part)
    // .fold(0_u32, |acc, num| acc + num.value.parse::<u32>().unwrap());
    println!("{}", res);
}
