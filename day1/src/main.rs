use std::fs;
fn main() {
    let path = "src/input.txt";
    let contents = fs::read_to_string(path);
    let lines: Vec<String> = contents
        .unwrap()
        .split_terminator('\n')
        .map(|line| line.to_owned())
        .collect();
    let mut sum = 0_u32;
    for line in lines {
        let nums: Vec<char> = line.chars().filter(|c| c.is_ascii_digit()).collect();
        if !nums.is_empty() {
            sum += format!("{}{}", nums.first().unwrap(), nums.last().unwrap())
                .parse::<u32>()
                .unwrap();
        }
    }
    println!("{}", sum);
}
