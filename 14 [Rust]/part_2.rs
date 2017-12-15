use std::collections::VecDeque;
mod knot;

fn main() {
    let base_str = "ffayrhll".to_string();
    let mut hashes = Vec::new();
    
    for i in 0..128 {
        let str_to_hash = base_str.clone() + &format!("-{}", i);
        let hashed = knot::hash(&str_to_hash);
        let bin_hashes: Vec<String> = hashed.iter().map(|x| format!("{:08b}", x)).collect();
        let str_hashed: String = bin_hashes.join("");
        hashes.push(str_hashed);
    }

    let mut matrix: [[bool; 128]; 128] = [[false; 128]; 128];

    for i in 0..128 {
        let hash = &hashes[i];
        let mut j = 0;
        for ch in hash.chars() {
            matrix[i][j] = ch == '1';
            j += 1;
        }
    }

    let mut regions = 0;
    let mut queue = VecDeque::new();
    for i in 0..128 {
        for j in 0..128 {
            if matrix[i][j] {
                regions += 1;
                queue.push_back((i,j));
            }

            while !queue.is_empty() {
                let coords = queue.pop_front().unwrap();
                let x = coords.0;
                let y = coords.1;
                if y < 127 && matrix[x][y+1] { queue.push_back((x, y+1)) }
                if y > 0 && matrix[x][y-1] { queue.push_back((x, y-1)) }
                if x < 127 && matrix[x+1][y] { queue.push_back((x+1, y)) }
                if x > 0 && matrix[x-1][y] { queue.push_back((x-1, y)) }
                matrix[x][y] = false;
            }
        }
    }

    print!("{}\n", regions);
}