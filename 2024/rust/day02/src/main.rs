use std::{
    fs::File,
    io::{prelude::*, BufReader},
};

fn main() {
    part1();
}

fn part1() {
    let file = File::open("input.txt").expect("couldn't open file");
    let reader = BufReader::new(file);

    let mut safe_reports = 0;

    for line in reader.lines() {
        let s = line.unwrap();
        let report = s
            .split(" ")
            .into_iter()
            .map(|st| st.parse::<i32>().unwrap())
            .collect::<Vec<i32>>();

        let is_decreasing = report[0] > report[1];
        let mut last = report[0];
        let mut safe = true;
        for (i, num) in report.iter().enumerate() {
            if i == 0 {
                continue;
            }

            if !is_decreasing && *num <= last {
                safe = false;
                break;
            }

            if is_decreasing && *num >= last {
                safe = false;
                break;
            }

            let diff = num - last;

            if diff.abs() > 3 {
                safe = false;
                break;
            }

            last = *num
        }

        if safe {
            safe_reports += 1;
        }
    }

    println!("Part 1: {}", safe_reports);
}
