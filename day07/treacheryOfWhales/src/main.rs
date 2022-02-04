use std::env;
use std::fs;

fn exponential_fuel(steps: i32) -> i32 {
    let mut fuel: i32 = 0;
    for i in 1..steps + 1 {
        fuel += i;
    }
    fuel
}

fn main() {
    let mut filename = "input.txt";
    let args: Vec<String> = env::args().collect();
    if args.len() > 1 {
        filename = &args[1];
    }

    let input = fs::read_to_string(filename).expect("Something went wrong reading the file");
    let mut crabs: Vec<i32> = input
        .trim()
        .split(',')
        .map(|s| s.parse().unwrap())
        .collect();
    crabs.sort();

    let position1: i32 = crabs[(crabs.len() as f32 / 2 as f32).floor() as usize];
    let mut position2: i32 = (crabs.iter().sum::<i32>() as f32 / crabs.len() as f32).floor() as i32;
    let mut fuel1: i32 = 0;
    let mut fuel2: i32 = 0;
    let mut fuel21: i32 = 0;

    for crab in crabs {
        fuel1 += (position1 - crab).abs();
        fuel2 += exponential_fuel((position2 - crab).abs());
        fuel21 += exponential_fuel((position2 + 1 - crab).abs());
    }

    if fuel2 > fuel21 {
        fuel2 = fuel21;
        position2 += 1;
    }

    println!("part 1: {}, aligning to {}", fuel1, position1);
    println!("part 2: {}, aligning to {}", fuel2, position2);
}
