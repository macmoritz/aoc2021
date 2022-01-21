use std::env;
use std::fs;

fn simulate(mut fishs: [u64; 9], days: i32) -> [u64; 9] {
    let mut temp: u64;
    for _ in 0..days {
        temp = fishs[0];
        fishs[0] = fishs[1];
        fishs[1] = fishs[2];
        fishs[2] = fishs[3];
        fishs[3] = fishs[4];
        fishs[4] = fishs[5];
        fishs[5] = fishs[6];
        fishs[6] = fishs[7] + temp;
        fishs[7] = fishs[8];
        fishs[8] = temp;
    }
    fishs
}

fn main() {
    let mut filename = "input.txt";
    let args: Vec<String> = env::args().collect();
    if args.len() > 1 {
        filename = &args[1];
    }

    let input = fs::read_to_string(filename).expect("Something went wrong reading the file");
    let initial: Vec<usize> = input.trim().split(',').map(|s| s.parse().unwrap()).collect();

    let mut fishs1: [u64; 9] = [0, 0, 0, 0, 0, 0, 0, 0, 0];
    let mut fishs2: [u64; 9] = [0, 0, 0, 0, 0, 0, 0, 0, 0];

    for fishs in initial {
        fishs1[fishs] += 1;
        fishs2[fishs] += 1;
    }

    fishs1 = simulate(fishs1, 80);
    fishs2 = simulate(fishs2, 256);

    println!("part 1: {}", fishs1.iter().sum::<u64>());
    println!("part 2: {}", fishs2.iter().sum::<u64>());
}
