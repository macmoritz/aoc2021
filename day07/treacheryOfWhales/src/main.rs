use std::env;
use std::fs;

fn exponential_fuel(steps: i32) -> i32 {
    let mut fuel: i32 = 0;
    for i in 1..steps {
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
    let crabs: Vec<i32> = input.trim().split(',').map(|s| s.parse().unwrap()).collect();

    let position1: i32 = (crabs.iter().sum::<i32>() as f32 / (crabs.len() * 2) as f32).round() as i32;
    let position2: i32 = (crabs.iter().sum::<i32>() as f32 / crabs.len() as f32).round() as i32;
    let mut fuel1: Vec<i32> = Vec::new();
    let mut fuel2: Vec<i32> = Vec::new();

    let mut j: usize = 0;
    for i in (position1 as f32 * 0.5) as i32..(position1 as f32 * 1.5) as i32 {
        fuel1.push(0);
        fuel2.push(0);
        for crab in &crabs {
            fuel1[j] += (i - crab).abs();
            fuel2[j] += exponential_fuel((i - crab).abs());
        }
        j += 1;
    }

    println!("part 1: {}", fuel1.iter().min().unwrap());
    println!("part 2: {}", fuel2.iter().min().unwrap());
}
