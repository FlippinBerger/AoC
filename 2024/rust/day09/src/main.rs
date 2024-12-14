use std::fs;

fn main() {
    let disk_map = fs::read_to_string("./input.txt").expect("Should have been able to read file");
    let disk_map = disk_map.trim();

    let mut disk: Vec<String> = vec![];

    // process the contents into a vec
    let mut id = 0;
    let radix: u32 = 10;
    for (i, c) in disk_map.chars().enumerate() {
        let num = c.to_digit(radix).expect("Couldn't parse the number");

        let is_even = i % 2 == 0;

        for _ in 0..num {
            if is_even {
                disk.push(id.to_string());
            } else {
                disk.push(".".to_owned())
            }
        }

        if is_even {
            id += 1;
        }
    }

    // reorder it
    compress_disk(&mut disk);

    let res = calculate_checksum(&disk);
    println!("the result is {}", res);

    part2(&disk_map);
}

fn compress_disk(v: &mut Vec<String>) {
    let mut end = v.len() - 1;

    for i in 0..v.len() - 1 {
        if v[i] != "." {
            continue;
        }

        while end > 0 && v[end] == "." {
            end -= 1;
        }

        if end <= i {
            return;
        }

        if v[i] == "." && v[end] != "." {
            let swap = v[i].clone();
            v[i] = v[end].clone();
            v[end] = swap;
            end -= 1;
        }
    }
}

fn calculate_checksum(v: &Vec<String>) -> u64 {
    let mut res: u64 = 0;

    for (i, s) in v.into_iter().enumerate() {
        if s == "." {
            continue;
        }

        let num = s.parse::<u64>().unwrap();
        let check = num * i as u64;
        res += check;
    }

    res
}

// 15943272103896 is too high
// 15934731934900 still too high
// 15933307860526 too high
fn part2(disk_map: &str) {
    let mut disk: Vec<String> = vec![];

    // process the contents into a vec, but this time use space markers
    let mut id = 0;
    let radix: u32 = 10;
    for (i, c) in disk_map.chars().enumerate() {
        let num = c.to_digit(radix).expect("Couldn't parse the number");

        let is_even = i % 2 == 0;

        let mut marker = if is_even {
            "MF-".to_owned()
        } else {
            "MD-".to_owned()
        };

        marker.push_str(&format!("{}", num));
        disk.push(marker);

        for _ in 0..num {
            if is_even {
                disk.push(id.to_string());
            } else {
                disk.push(".".to_owned())
            }
        }

        if is_even {
            id += 1;
        }
    }

    full_file_compress(&mut disk);
    let filtered_disk = disk
        .into_iter()
        .filter(|s| !s.starts_with("M"))
        .collect::<Vec<String>>();

    let res = calculate_checksum(&filtered_disk);
    println!("Part 2 res: {}", res);
}

fn full_file_compress(v: &mut Vec<String>) {
    let mut f_ptr = v.len() - 1;

    while f_ptr > 0 {
        while f_ptr > 0 && !v[f_ptr].starts_with("MF") {
            f_ptr -= 1;
        }

        println!("first pos thing is {}", v[f_ptr]);

        if f_ptr < 1 {
            return;
        }

        let num_s: &str = v[f_ptr].split("-").collect::<Vec<_>>()[1];
        let num = num_s.parse::<usize>().unwrap();

        println!("num is {}", num);

        let mut free_ptr = 0;
        for i in 0..f_ptr - 1 {
            if !v[i].starts_with("MD") {
                continue;
            }

            let check_num_s: &str = v[i].split("-").collect::<Vec<_>>()[1];
            let check_num = check_num_s.parse::<usize>().unwrap();
            println!("file size: {} space: {}", num, check_num);
            if check_num >= num {
                free_ptr = i;
                break;
            }
        }

        if free_ptr > 0 && free_ptr <= f_ptr - 1 {
            println!("---swappin!---");
            for i in 0..num {
                let swap = v[free_ptr + 1 + i].clone();
                v[free_ptr + 1 + i] = v[f_ptr + 1 + i].clone();
                v[f_ptr + 1 + i] = swap;
            }
        }

        println!("file_ptr: {} free_ptr: {}", f_ptr, free_ptr);
        f_ptr -= 1;

        if f_ptr <= free_ptr {
            return;
        }
    }
}
