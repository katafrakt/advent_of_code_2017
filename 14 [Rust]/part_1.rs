
mod knot;

fn main() {
    let base_str = "ffayrhll".to_string();
    let mut ones_count = 0;

    for i in 0..128 {
        let str_to_hash = base_str.clone() + &format!("-{}", i);
        let hashed = knot::hash(&str_to_hash);
        let bin_hashes: Vec<String> = hashed.iter().map(|x| format!("{:b}", x)).collect();
        let str_hashed: String = bin_hashes.join("");
        let ones = str_hashed.chars().filter(|&x| x == '1').count();
        ones_count += ones;
    }

    print!("{:?}\n", ones_count);
}