use std::fs;
// fn spelled
fn main() {
    let path = "src/input.txt";
    let contents = fs::read_to_string(path);
    let lines: Vec<String> = contents
        .unwrap()
        .lines()
        .map(|line| line.to_owned())
        .collect();
    let mut sum = 0_u32;
    for line in lines {
        let line = line.replace("one", "o1e");
        let line = line.replace("two", "t2o");
        let line = line.replace("three", "t3e");
        let line = line.replace("four", "f4");
        let line = line.replace("five", "f5e");
        let line = line.replace("six", "s6");
        let line = line.replace("seven", "s7n");
        let line = line.replace("eight", "e8t");
        let line = line.replace("nine", "n9e");
        let nums: Vec<char> = line.chars().filter(|c| c.is_ascii_digit()).collect();
        if !nums.is_empty() {
            sum += format!("{}{}", nums.first().unwrap(), nums.last().unwrap())
                .parse::<u32>()
                .unwrap();
        }
    }
    println!("{}", sum);
}
