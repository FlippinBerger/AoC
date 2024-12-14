use std::{collections::HashSet, fs};

fn main() {
    let s = fs::read_to_string("input.txt").expect("couldn't read the input");

    part1(&s);
    part2(&s);
}

fn part1(input: &str) {
    let mut v1: Vec<i32> = vec![];
    let mut v2: Vec<i32> = vec![];

    let ss: Vec<&str> = input.split("\n").collect();

    for line in ss {
        if line.is_empty() {
            break;
        }
        let mut iter = line.split_whitespace();

        let a = iter.next().unwrap();
        v1.push(a.parse::<i32>().unwrap());

        let b = iter.next().unwrap();
        v2.push(b.parse::<i32>().unwrap());
    }

    v1.sort();
    v2.sort();

    let mut distance = 0;
    for (i, num) in v1.iter().enumerate() {
        distance += (num - v2[i]).abs();
    }

    println!("part1: {}", distance);
}

fn part2(input: &str) {
    let mut v1: Vec<i32> = vec![];
    let mut v2: Vec<i32> = vec![];

    let ss: Vec<&str> = input.split("\n").collect();
    let mut set: HashSet<i32> = HashSet::new();

    for line in ss {
        if line.is_empty() {
            break;
        }
        let mut iter = line.split_whitespace();

        let a = iter.next().unwrap();
        let num = a.parse::<i32>().unwrap();
        v1.push(num);
        set.insert(num);

        let b = iter.next().unwrap();
        v2.push(b.parse::<i32>().unwrap());
    }

    let mut score = 0;
    for num in v2.iter() {
        if set.contains(num) {
            score += num;
        }
    }

    println!("part2: {}", score);
}
